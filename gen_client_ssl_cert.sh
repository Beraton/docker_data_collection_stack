#!/bin/bash

[[ "$(whoami)" != root ]] && echo "Please run as root." >&2 && exit 1

read -p "Please provide certificate name to generate: " certname

if [[ -d "$certname.out" ]]
then
  printf "=== Changing to output directory: %s ===\n" "$certname.out"
  cd $certname.out
else
  printf "=== Creating output directory: %s ===\n" "$certname.out"
  mkdir $certname.out && cd $certname.out
fi

printf "=== Current dir: ${PWD} ===\n" 

if [[ -f "$certname.key" ]]
then
  matching_files=$(find . -type f -name "*.key" -printf x | wc -c)
  if [[ matching_files -gt 1 ]]
  then
    printf "=== ERROR: found multiple files with .key extension. Try removing redundant files and leave ONLY one. ===\n"
    exit 1
  elif [[ matching_files -eq 1 ]]
  then
    target_name=$(basename -s .key $(find . -type f -name "*.key"))
    printf "=== Found SSL key: %s, skipping new key generation ===\n" "$target_name.key"
  fi
else
  target_name=$certname
  printf "CERTNAME: %s\n" $certname
  printf "TARGET_NAME: %s\n" $target_name
  printf "=== Generating new key file ===\n"
  openssl genrsa -out "${target_name}.key" 2048
fi


printf "=== Creating certificate sign request: ===\n" "$target_name.csr"
openssl req -new -out $target_name.csr -key $target_name.key
printf "=== Creating certificate from .csr file ===\n"
read -p "Enter absolute directory path where root CA certificate and key are stored: " capath
sudo openssl x509 -req -in $target_name.csr -CA $capath/ca.crt -CAkey $capath/ca.key -CAcreateserial -out $target_name.crt -days 360

if [[ $? -ne 0 ]] 
then
  printf "=== ERROR: certificate creation was unsuccessful ===\n"
  exit 1
else
  printf "=== Successfully created certificate ===\n"
fi


