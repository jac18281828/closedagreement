# Closed Agreement

## A private agreement between two parties.

This contract implements a private agreement between two parties. The agreement is kept in secret
however it may be revealed by either party at any time if they share it publicly.

Demonstrates:

- off-chain signing
- rpc interactions
- privacy and brokered agreements

# Getting Started

1. visit .env, env.example has been provided
2. fill all relevant variables

# Build and Test

## This project works best with Docker

1.  Load the project in VSCode Remote Containers Extension or in a CodeSpace

Or

1. full build and test via docker command line

`$ sh build.sh`

# Deployment (Optional)

Deployment scripts are provided. Deployment requires access to a private key and TestNet RPC instance
as well as an ETHERSCAN_API_KEY.

1. `$ yarn deploylibrary`
   Get the address of the constant library and set it in `CONSTANT_LIB_ADDRESS`
   This has already be configured to 0x1396262031838905d3787F0A517Fa3CaCF33FA04 in package.json
2. `$ yarn deploy`
   This will deploy the ClosedAgreement contract

Note: If you are depending on environment variables in .env you may have to export these for yarn as well
`$ export RPC_URL=https://provider...`

# Sepolia TestNet

This contract is already deployed with the following details:

| Contract        | Ethereum Address                           | Etherscan                                                                       |
| --------------- | ------------------------------------------ | ------------------------------------------------------------------------------- |
| ECDSA           | 0x18F3510E1a11C502781e5E8E1FD2365fAa789Bb2 | https://sepolia.etherscan.io/address/0x18f3510e1a11c502781e5e8e1fd2365faa789bb2 |
| ClosedAgreement | 0x3cb46d7079d74fb0a66e4f949a3d2b3e9be62006 | https://sepolia.etherscan.io/address/0x3cb46d7079d74fb0a66e4f949a3d2b3e9be62006 |

# Testing

1. setup the .env to have suitable values for message and parties
2. create an agreement
   `$ yarn create_agreement`
   make a note of the agreement hash
3. optionall reveal the agrement
   `$ yarn reveal hash`

# Below is an example of a successful transaction

Agreement for `0x6CCEF4A336990D1C3C52B7A0624D811B7EDDECB4825E3EC9CE7AE57F4FA2D9C7`

1. create_agreement
   https://sepolia.etherscan.io/tx/0x79c531d8ce265333508e72e0db929dea4198dad196f397bfaaac8ebbb51fdddd
2. reveal
   https://sepolia.etherscan.io/tx/0x81a134111e684c63180a539d506f190fb6f1d895a2662adb25369cbc0c0c0794
