['/*\n', ' * Contracts&#39; names:\n', ' * 1) UserfeedsClaim - prefix\n', ' * 2a) WithoutValueTransfer - simplest case, no transfer\n', ' * 2b) With - continuation\n', ' * 3) Configurable - optional, means there is function parameter to decide how much to send to each recipient\n', ' * 4) Value or Token - value means ether, token means ERC20 or ERC721\n', ' * 5) Multi - optional, means there are multiple recipients\n', ' * 6) Send or Transfer - using send or transfer in case of ether, or transferFrom in case of ERC20/ERC721 (no "Send" possible in this case)\n', ' * 7) Unsafe or NoCheck - optional, means that value returned from send or transferFrom is not checked\n', ' */\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract ERC20 {\n', '\n', '  function transferFrom(address from, address to, uint value) public returns (bool success);\n', '}\n', '\n', 'contract ERC721 {\n', '\n', '  function transferFrom(address from, address to, uint value) public;\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address owner;\n', '  address pendingOwner;\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier onlyPendingOwner {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  function claimOwnership() public onlyPendingOwner {\n', '    owner = pendingOwner;\n', '  }\n', '}\n', '\n', 'contract Destructible is Ownable {\n', '\n', '  function destroy() public onlyOwner {\n', '    selfdestruct(msg.sender);\n', '  }\n', '}\n', '\n', 'contract WithClaim {\n', '\n', '  event Claim(string data);\n', '}\n', '\n', '// older version:\n', '// Mainnet: 0xFd74f0ce337fC692B8c124c094c1386A14ec7901\n', '// Rinkeby: 0xC5De286677AC4f371dc791022218b1c13B72DbBd\n', '// Ropsten: 0x6f32a6F579CFEed1FFfDc562231C957ECC894001\n', '// Kovan:   0x139d658eD55b78e783DbE9bD4eb8F2b977b24153\n', '\n', 'contract UserfeedsClaimWithoutValueTransfer is Destructible, WithClaim {\n', '\n', '  function post(string data) public {\n', '    emit Claim(data);\n', '  }\n', '}\n', '\n', '// older version:\n', '// Mainnet: 0x70B610F7072E742d4278eC55C02426Dbaaee388C\n', '// Rinkeby: 0x00034B8397d9400117b4298548EAa59267953F8c\n', '// Ropsten: 0x37C1CA7996CDdAaa31e13AA3eEE0C89Ee4f665B5\n', '// Kovan:   0xc666c75C2bBA9AD8Df402138cE32265ac0EC7aaC\n', '\n', 'contract UserfeedsClaimWithValueTransfer is Destructible, WithClaim {\n', '\n', '  function post(address userfeed, string data) public payable {\n', '    emit Claim(data);\n', '    userfeed.transfer(msg.value);\n', '  }\n', '}\n', '\n', '// older version:\n', '// Mainnet: 0xfF8A1BA752fE5df494B02D77525EC6Fa76cecb93\n', '// Rinkeby: 0xBd2A0FF74dE98cFDDe4653c610E0E473137534fB\n', '// Ropsten: 0x54b4372fA0bd76664B48625f0e8c899Ff19DFc39\n', '// Kovan:   0xd6Ede7F43882B100C6311a9dF801088eA91cEb64\n', '\n', 'contract UserfeedsClaimWithTokenTransfer is Destructible, WithClaim {\n', '\n', '  function post(address userfeed, ERC20 token, uint value, string data) public {\n', '    emit Claim(data);\n', '    require(token.transferFrom(msg.sender, userfeed, value));\n', '  }\n', '}\n', '\n', '// Rinkeby: 0x73cDd7e5Cf3DA3985f985298597D404A90878BD9\n', '// Ropsten: 0xA7828A4369B3e89C02234c9c05d12516dbb154BC\n', '// Kovan:   0x5301F5b1Af6f00A61E3a78A9609d1D143B22BB8d\n', '\n', 'contract UserfeedsClaimWithValueMultiSendUnsafe is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients) public payable {\n', '    emit Claim(data);\n', '    send(recipients);\n', '  }\n', '\n', '  function post(string data, bytes20[] recipients) public payable {\n', '    emit Claim(data);\n', '    send(recipients);\n', '  }\n', '\n', '  function send(address[] recipients) public payable {\n', '    uint amount = msg.value / recipients.length;\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      recipients[i].send(amount);\n', '    }\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '\n', '  function send(bytes20[] recipients) public payable {\n', '    uint amount = msg.value / recipients.length;\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      address(recipients[i]).send(amount);\n', '    }\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '}\n', '\n', '// Mainnet: 0xfad31a5672fbd8243e9691e8a5f958699cd0aaa9\n', '// Rinkeby: 0x1f8A01833A0B083CCcd87fffEe50EF1D35621fD2\n', '// Ropsten: 0x298611B2798d280910274C222A9dbDfBA914B058\n', '// Kovan:   0x0c20Daa719Cd4fD73eAf23d2Cb687cD07d500E17\n', '\n', 'contract UserfeedsClaimWithConfigurableValueMultiTransfer is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients, uint[] values) public payable {\n', '    emit Claim(data);\n', '    transfer(recipients, values);\n', '  }\n', '\n', '  function transfer(address[] recipients, uint[] values) public payable {\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      recipients[i].transfer(values[i]);\n', '    }\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '}\n', '\n', '// Rinkeby: 0xA105908d1Bd7e76Ec4Dfddd08d9E0c89F6B39474\n', '// Ropsten: 0x1A97Aba0fb047cd8cd8F4c14D890bE6E7004fae9\n', '// Kovan:   0xcF53D90E7f71C7Db557Bc42C5a85D36dD53956C0\n', '\n', 'contract UserfeedsClaimWithConfigurableTokenMultiTransfer is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients, ERC20 token, uint[] values) public {\n', '    emit Claim(data);\n', '    transfer(recipients, token, values);\n', '  }\n', '\n', '  function transfer(address[] recipients, ERC20 token, uint[] values) public {\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      require(token.transferFrom(msg.sender, recipients[i], values[i]));\n', '    }\n', '  }\n', '}\n', '\n', '// Rinkeby: 0x042a52f30572A54f504102cc1Fbd1f2B53859D8A\n', '// Ropsten: 0x616c0ee7C6659a99a99A36f558b318779C3ebC16\n', '// Kovan:   0x30192DE195f393688ce515489E4E0e0b148e9D8d\n', '\n', 'contract UserfeedsClaimWithConfigurableTokenMultiTransferNoCheck is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients, ERC721 token, uint[] values) public {\n', '    emit Claim(data);\n', '    transfer(recipients, token, values);\n', '  }\n', '\n', '  function transfer(address[] recipients, ERC721 token, uint[] values) public {\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      token.transferFrom(msg.sender, recipients[i], values[i]);\n', '    }\n', '  }\n', '}']
['/*\n', " * Contracts' names:\n", ' * 1) UserfeedsClaim - prefix\n', ' * 2a) WithoutValueTransfer - simplest case, no transfer\n', ' * 2b) With - continuation\n', ' * 3) Configurable - optional, means there is function parameter to decide how much to send to each recipient\n', ' * 4) Value or Token - value means ether, token means ERC20 or ERC721\n', ' * 5) Multi - optional, means there are multiple recipients\n', ' * 6) Send or Transfer - using send or transfer in case of ether, or transferFrom in case of ERC20/ERC721 (no "Send" possible in this case)\n', ' * 7) Unsafe or NoCheck - optional, means that value returned from send or transferFrom is not checked\n', ' */\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract ERC20 {\n', '\n', '  function transferFrom(address from, address to, uint value) public returns (bool success);\n', '}\n', '\n', 'contract ERC721 {\n', '\n', '  function transferFrom(address from, address to, uint value) public;\n', '}\n', '\n', 'contract Ownable {\n', '\n', '  address owner;\n', '  address pendingOwner;\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  modifier onlyPendingOwner {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  function claimOwnership() public onlyPendingOwner {\n', '    owner = pendingOwner;\n', '  }\n', '}\n', '\n', 'contract Destructible is Ownable {\n', '\n', '  function destroy() public onlyOwner {\n', '    selfdestruct(msg.sender);\n', '  }\n', '}\n', '\n', 'contract WithClaim {\n', '\n', '  event Claim(string data);\n', '}\n', '\n', '// older version:\n', '// Mainnet: 0xFd74f0ce337fC692B8c124c094c1386A14ec7901\n', '// Rinkeby: 0xC5De286677AC4f371dc791022218b1c13B72DbBd\n', '// Ropsten: 0x6f32a6F579CFEed1FFfDc562231C957ECC894001\n', '// Kovan:   0x139d658eD55b78e783DbE9bD4eb8F2b977b24153\n', '\n', 'contract UserfeedsClaimWithoutValueTransfer is Destructible, WithClaim {\n', '\n', '  function post(string data) public {\n', '    emit Claim(data);\n', '  }\n', '}\n', '\n', '// older version:\n', '// Mainnet: 0x70B610F7072E742d4278eC55C02426Dbaaee388C\n', '// Rinkeby: 0x00034B8397d9400117b4298548EAa59267953F8c\n', '// Ropsten: 0x37C1CA7996CDdAaa31e13AA3eEE0C89Ee4f665B5\n', '// Kovan:   0xc666c75C2bBA9AD8Df402138cE32265ac0EC7aaC\n', '\n', 'contract UserfeedsClaimWithValueTransfer is Destructible, WithClaim {\n', '\n', '  function post(address userfeed, string data) public payable {\n', '    emit Claim(data);\n', '    userfeed.transfer(msg.value);\n', '  }\n', '}\n', '\n', '// older version:\n', '// Mainnet: 0xfF8A1BA752fE5df494B02D77525EC6Fa76cecb93\n', '// Rinkeby: 0xBd2A0FF74dE98cFDDe4653c610E0E473137534fB\n', '// Ropsten: 0x54b4372fA0bd76664B48625f0e8c899Ff19DFc39\n', '// Kovan:   0xd6Ede7F43882B100C6311a9dF801088eA91cEb64\n', '\n', 'contract UserfeedsClaimWithTokenTransfer is Destructible, WithClaim {\n', '\n', '  function post(address userfeed, ERC20 token, uint value, string data) public {\n', '    emit Claim(data);\n', '    require(token.transferFrom(msg.sender, userfeed, value));\n', '  }\n', '}\n', '\n', '// Rinkeby: 0x73cDd7e5Cf3DA3985f985298597D404A90878BD9\n', '// Ropsten: 0xA7828A4369B3e89C02234c9c05d12516dbb154BC\n', '// Kovan:   0x5301F5b1Af6f00A61E3a78A9609d1D143B22BB8d\n', '\n', 'contract UserfeedsClaimWithValueMultiSendUnsafe is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients) public payable {\n', '    emit Claim(data);\n', '    send(recipients);\n', '  }\n', '\n', '  function post(string data, bytes20[] recipients) public payable {\n', '    emit Claim(data);\n', '    send(recipients);\n', '  }\n', '\n', '  function send(address[] recipients) public payable {\n', '    uint amount = msg.value / recipients.length;\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      recipients[i].send(amount);\n', '    }\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '\n', '  function send(bytes20[] recipients) public payable {\n', '    uint amount = msg.value / recipients.length;\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      address(recipients[i]).send(amount);\n', '    }\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '}\n', '\n', '// Mainnet: 0xfad31a5672fbd8243e9691e8a5f958699cd0aaa9\n', '// Rinkeby: 0x1f8A01833A0B083CCcd87fffEe50EF1D35621fD2\n', '// Ropsten: 0x298611B2798d280910274C222A9dbDfBA914B058\n', '// Kovan:   0x0c20Daa719Cd4fD73eAf23d2Cb687cD07d500E17\n', '\n', 'contract UserfeedsClaimWithConfigurableValueMultiTransfer is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients, uint[] values) public payable {\n', '    emit Claim(data);\n', '    transfer(recipients, values);\n', '  }\n', '\n', '  function transfer(address[] recipients, uint[] values) public payable {\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      recipients[i].transfer(values[i]);\n', '    }\n', '    msg.sender.transfer(address(this).balance);\n', '  }\n', '}\n', '\n', '// Rinkeby: 0xA105908d1Bd7e76Ec4Dfddd08d9E0c89F6B39474\n', '// Ropsten: 0x1A97Aba0fb047cd8cd8F4c14D890bE6E7004fae9\n', '// Kovan:   0xcF53D90E7f71C7Db557Bc42C5a85D36dD53956C0\n', '\n', 'contract UserfeedsClaimWithConfigurableTokenMultiTransfer is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients, ERC20 token, uint[] values) public {\n', '    emit Claim(data);\n', '    transfer(recipients, token, values);\n', '  }\n', '\n', '  function transfer(address[] recipients, ERC20 token, uint[] values) public {\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      require(token.transferFrom(msg.sender, recipients[i], values[i]));\n', '    }\n', '  }\n', '}\n', '\n', '// Rinkeby: 0x042a52f30572A54f504102cc1Fbd1f2B53859D8A\n', '// Ropsten: 0x616c0ee7C6659a99a99A36f558b318779C3ebC16\n', '// Kovan:   0x30192DE195f393688ce515489E4E0e0b148e9D8d\n', '\n', 'contract UserfeedsClaimWithConfigurableTokenMultiTransferNoCheck is Destructible, WithClaim {\n', '\n', '  function post(string data, address[] recipients, ERC721 token, uint[] values) public {\n', '    emit Claim(data);\n', '    transfer(recipients, token, values);\n', '  }\n', '\n', '  function transfer(address[] recipients, ERC721 token, uint[] values) public {\n', '    for (uint i = 0; i < recipients.length; i++) {\n', '      token.transferFrom(msg.sender, recipients[i], values[i]);\n', '    }\n', '  }\n', '}']
