# Closed Agreement

## A private agreement between two parties.

This contract implements a private agreement between two parties. The agreement is kept in secret
however it may be revealed by either party at any time if they share it publicly.

# Build and Test

## This project works best with Docker

1.  Load the project in VSCode Remote Containers Extension or a CodeSpace

Or

1. full build and test via dockdr

`$ sh build.sh`

# Deployment

Deployment scripts are provided. This requires access to a private key and TestNet RPC instance

1. `$ yarn deployconstant`
   get the address of the constant library and set it in `CONSTANT_LIB_ADDRESS`
2. `$ yarn deploy`
   this will deploy the ClosedAgreement contract

# Sepolia TestNet

This contract is already deployed with the following details:

"Update contract address here"

# Testing

1. setup the .env to have suitable values for message and parties
2. create an agreement
   `$ yarn create_agreement`
   make a note of the agreement hash
3. optionall reveal the agrement
   `$ yarn reveal hash`
