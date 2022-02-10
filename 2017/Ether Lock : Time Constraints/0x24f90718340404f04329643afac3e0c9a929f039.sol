['pragma solidity ^0.4.8;\n', '\n', 'contract XBL_ERC20Wrapper\n', '{\n', '    function transferFrom(address from, address to, uint value) returns (bool success);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    function burn(uint256 _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function totalSupply() constant returns (uint256 total_supply);\n', '}\n', '\n', '\n', 'contract MassSend\n', '{\n', '\taddress[] addresses;\n', '\tXBL_ERC20Wrapper private ERC20_CALLS;\n', '\tuint256 ticket_price;\n', '\taddress own_addr = address(this);\n', '\n', '\tfunction MassSend()\n', '\t{\n', '\t\tticket_price = 10000000000000000000;\n', '\t\tERC20_CALLS = XBL_ERC20Wrapper(0x49AeC0752E68D0282Db544C677f6BA407BA17ED7);\n', '\n', '\t\taddresses.push(0xca10068178e956a3d5b456e1c6f19e6e9bb92112);\n', '\t\taddresses.push(0x3538d0a1b071D6232E46d7B75a8589d409f14B94);\n', '\t\taddresses.push(0x2407f7252908ddadffb05bf03e3ac103fe633c93);\n', '\t\taddresses.push(0x1fD54e04911Aaf62e8539D2596414609b398c084);\n', '\t\taddresses.push(0xcd5280456546194C92d0Fa2404f4619A73c92C56);\n', '\t\taddresses.push(0xb5fa196F37d8A0BF2eCbbf557Bd428131990c04C);\n', '\t\taddresses.push(0xe5427789bc79c7fb717eae8452ce48fa4f9d92a8);\n', '\t\taddresses.push(0xC864DACcD2513bdC71bF8a09A95d597A6A426f99);\n', '\t\taddresses.push(0x2254dC06b7A75bA980b9f1Aed2b9312a4D803C3B);\n', '\t\taddresses.push(0xb5C1008412049D13743a69A61b638f6399c8822c);\n', '\t\taddresses.push(0x77d316f0711506cb93f0a7491f2887315fe16ece);\n', '\t\taddresses.push(0x016B94671686fd6b9481255188e282E0771633C3);\n', '\t\taddresses.push(0x6a496667Ba9e7dc41967F23d19CfF562a81DFb56);\n', '\t\taddresses.push(0xdb6fEC9F30f7A4aC333AF3F629F388d319A46870);\n', '\t\taddresses.push(0x1Daf1c4Ba83208d39400145423d119E8A34D1B74);\n', '\t\taddresses.push(0xe833266083A879dF83642378fD186908B1ad8093);\n', '\t\taddresses.push(0x92c10DaE526551CaF016501195dc1616e78066dc);\n', '\t\taddresses.push(0xE8f760BAE76d056DdA12947b4E9BaFB9C348Ea05);\n', '\t\taddresses.push(0xa1cc8a1e4c195f23b09fb1a99f20cbd9e7ca3f6a);\n', '\t\taddresses.push(0x6682987032d400C2C169F0afA15a030b01012276);\n', '\t\taddresses.push(0x0a05005f9637a8140f88393d5eed051e14833738);\n', '\t\taddresses.push(0x28f8ecD55C69f1BC09db5C7fAfE6C7A533361E76);\n', '\t\taddresses.push(0xDA619Ff35B17FF87Ee81063c078f3830C0fa4783);\n', '\t\taddresses.push(0x6f9D0d2edc038455c16b9215F826Ca27DA338aBb);\n', '\t\taddresses.push(0x211a07Fbb31f05A0c1353685C94A4D51481E952C);\n', '\t\taddresses.push(0x643697B24E4c666a597cf1611cED60966c5D76FA);\n', '\t\taddresses.push(0x599B44F23e7f557c7C01D135e11121E0Ec033ccB);\n', '\t\taddresses.push(0xc01E30e08384927919ce7c464aFC97826A66D6c6);\n', '\t\taddresses.push(0xd027DdC5af6332779a65859D225d9B8Bc71AC68B);\n', '\t\taddresses.push(0x6E61679C0cE12685C025DF0171f50bC7cC9951a6);\n', '\t\taddresses.push(0x8A9902C77aDCF91F3C3445aEBDABbC67B435FB50);\n', '\t\taddresses.push(0xa37d6Aa9c93C47E7C126041f66166BcA84353c15);\n', '\t\taddresses.push(0x22A2CcEc398Bfb310FD91c1D5C95C9004adEa8ee);\n', '\t\taddresses.push(0xbedE750d17Ab647cAb6b45B8765347DFF3fBb89A);\n', '\t\taddresses.push(0x611DC0BC1F34acb345c4b15d0bb4956D7f577352);\n', '\t\taddresses.push(0xF7C8EABfcAA4312AB54c00a8d6A211Beb317e29E);\n', '\t\taddresses.push(0xaCB821996C35F6f6feEF57F59E28fd20990b2AF2);\n', '\t\taddresses.push(0xfe080A56C077f714Af1C4C8053b062F9b1780BA0);\n', '\t\taddresses.push(0x88216428e5d63491e66711051e37Eb47E7CDa8D3);\n', '\t\taddresses.push(0xe58c100b4A3E08F5cdBD954e2CbbB5b7E7a52b15);\n', '\t\taddresses.push(0x69d1fb9235161e566b85166a2c5f75442ccf345e);\n', '\t\taddresses.push(0x61883158A270AEB30FE52Ea5a33B3BfDF4e41EC4);\n', '\t\taddresses.push(0xF1b756B5CF793412b9e1AAc97654aE26385891Ba);\n', '\t\taddresses.push(0xf0D8444b98fD316D6fa97EF6D9501f457E72656F);\n', '\t\taddresses.push(0xce4da14bb5d72dda7132f4116fb056db7039b214);\n', '\t\taddresses.push(0x05c2E47c3676cB577850A363f07c26915F62B20C);\n', '\t\taddresses.push(0xeC876B4CAf344d0aD24F2cC77B9c5DD0506C70c1);\n', '\t\taddresses.push(0x2556eAA685ddD0CdCeb5BEda634ABe0f840E84F7);\n', '\t\taddresses.push(0x932B9158BB90C25ab134C6E08Cf78B3eC3072202);\n', '\t\taddresses.push(0xE7dF38D14AF89DE04E65ff184C836865ee33109c);\n', '\t}\n', '\n', '\tfunction send_all()\n', '\t{\n', '\t\tfor (uint256 i = 0; i < addresses.length; i++)\n', '\t\t{\n', '\t\t\tERC20_CALLS.transfer(addresses[i], ticket_price);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction sanity_check() public returns (bool success)\n', '\t{\n', '\t\tif ((ERC20_CALLS.balanceOf(own_addr) == ticket_price * 50) || (addresses.length == 50))\n', '\t\t{\n', '\t\t\treturn true;\n', '\t\t}\n', '\t\telse\n', '\t\t{\n', '\t\t\treturn false;\n', '\t\t}\n', '\t}\n', '\n', '\tfunction safe_withdraw(uint256 number_of_tokens)\n', '\t{\n', '\t\tERC20_CALLS.transfer(msg.sender, number_of_tokens);\n', '\t}\n', '}']