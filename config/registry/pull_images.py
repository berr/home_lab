from pathlib import Path
import subprocess

def pull_images(images_file):
    images = list(read_images(images_file))

    for image in images:
        pull_image(image)

def pull_image(image: str):
    id, tag = image.rsplit(":", 1)

    split_id = id.rsplit("/", 1)
    if len(split_id) <= 3:
        split_id = [None] * (3 - len(split_id)) + split_id
        registry, user, name = split_id
    else:
        raise RuntimeError(f"Unexpected id: {id}",)
 
    print("Pulling: ", image)
    subprocess.run(["docker", "pull", image], stdout=subprocess.DEVNULL)

    print("  Tagging")
    local_name = f"registry.berr.dev/{name}:deployed"
    subprocess.run(["docker", "tag", image, local_name], stdout=subprocess.DEVNULL)

    print("  Pushing to: ", local_name)
    subprocess.run(["docker", "push", local_name], stdout=subprocess.DEVNULL)
    print("  Deleting: ", image, local_name)
    subprocess.run(["docker", "rmi", image, local_name], stdout=subprocess.DEVNULL)
    print("  Done")



def read_images(images_file):
    with open(images_file) as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("#"):
                continue
            
            yield line


if __name__ == "__main__":
    import sys
    pull_images(Path(sys.argv[1]).absolute())
