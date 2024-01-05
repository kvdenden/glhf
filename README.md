## GLHF

- Create a `.env` file with your configuration. You can copy `.env.example` as a starting point.
- Run a local blockchain using `yarn anvil`
- Deploy contracts using `yarn deploy`
- Enable allowlist sale with `yarn init-sale`
- Start auction with `yarn start-auction`
- You can use `cast` to make custom contract calls from your CLI.

## Usage

### Install

```shell
$ forge install --no-commit
```

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Anvil (local blockchain)

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Deploy.s.sol:DeployScript --rpc-url <your_rpc_url> --broadcast --verify
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
