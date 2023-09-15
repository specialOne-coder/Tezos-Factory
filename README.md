##  NFT FACTORY Contract

- L’Administrateur peut ajouter/supprimer d’autres administrateurs,
- Un nouvel Administrateur doit accepter son rôle avant qu’il ne soit effectif,
- L’Administrateur peut bannir (sur une blacklist) des Creators,
- Un utilisateur peut payer 10 tez pour participer au contrat (sur une whitelist de Creators),
- Un utilisateur whitelisté peut créer des Collections NFTs FA2 en spécifiant les paramètres nécessaires,
- Une vue qui permettra de retourner les collections créé par user

## Pre-requisites

You need to install the following tools:

- [NodeJS & Npm](https://nodejs.org/en/download/)
- [LIGO](https://ligolang.org/docs/intro/installation/) **or** [Docker](https://docs.docker.com/get-docker/)

## How to use this template ?

### Env file

create ```.env``` file in ```deploy``` folder and provide theses variables:

```
PK=YOUR_GHOSTNET_PRIVATEKEY
RPC_URL=https://ghostnet.tezos.marigold.dev/
SANDBOX_URL=http://localhost:20000
SANDBOX_PK=edsk3QoqBuvdamxouPhin7swCvkQNgq4jP5KZPbwWNnwdZpSpJiEbq

```
### Compilation

A makefile is provided to compile the "Factory" smart contract.

```
make compile
```

You can also override `make` parameters by running :

```sh
make compile ligo_compiler=<LIGO_EXECUTABLE> protocol_opt="--protocol <PROTOCOL>"
```

### Tests

A makefile is provided to launch tests. Make test execute the possible scenarios

```
make test
```

### Deployment

A typescript script for deployment is provided to originate the smart contrat. This deployment script relies on .env file which provides the RPC node url and the deployer public and private key.
So make sure to rename `deploy/.env.dist` to `deploy/.env` and **fill the required variables**.

```
make deploy
```

## Sandbox 

### Running 

You can run flextesa sandbox by running 

```
make sandbox-start
```

### Deployment 

You can deploy the contract on flextesa sandbox by running 

```
make sandbox-deploy
```
