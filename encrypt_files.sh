#!/bin/bash -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ENCRYPTED_DIR="${SCRIPT_DIR}/private_encrypted"
DECRYPTED_DIR="${SCRIPT_DIR}/private"

PASSWORD="$1"

cd "$SCRIPT_DIR"
for FILE_NAME in $(find private -type f -not -path '*/.*' | cut -d / -f 2-)
do
    DECRYPTED_FILE="${DECRYPTED_DIR}/${FILE_NAME}"
    ENCRYPTED_FILE="${ENCRYPTED_DIR}/${FILE_NAME}"
    mkdir -p $(dirname "${ENCRYPTED_FILE}")
    gpg -c --batch --yes --passphrase "$PASSWORD" --armor -o "$ENCRYPTED_FILE" "$DECRYPTED_FILE"
done

