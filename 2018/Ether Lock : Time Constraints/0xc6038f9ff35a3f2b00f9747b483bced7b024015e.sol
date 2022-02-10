['pragma solidity ^0.4.25;\n', '/**\n', '*\n', '* ETH CRYPTOCURRENCY DISTRIBUTION PROJECT\n', '* \n', '*  - GAIN 4% PER 24 HOURS (every 5900 blocks)\n', '*  - Life-long payments\n', '*  - The revolutionary reliability\n', '*  - Minimal contribution 0.01 eth\n', '*  - Currency and payment - ETH\n', '*  - Contribution allocation schemes:\n', '*    -- 85% payments\n', '*    -- 15% Marketing + Operating Expenses\n', '*\n', '*   ---About the Project\n', '*  Blockchain-enabled smart contracts have opened a new era of trustless relationships without \n', '*  intermediaries. This technology opens incredible financial possibilities. Our automated investment \n', '*  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be \n', '*  freely accessed online. In order to insure our investors&#39; complete security, full control over the \n', '*  project has been transferred from the organizers to the smart contract: nobody can influence the \n', '*  system&#39;s permanent autonomous functioning.\n', '* \n', '* ---How to use:\n', '*  1. Send from ETH wallet to this smart contract address\n', '*     any amount from 0.01 ETH.\n', '*  2. Verify your transaction in the history of your application or etherscan.io, specifying the address \n', '*     of your wallet.\n', '*  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don&#39;t care unless you&#39;re \n', '*      spending too much on GAS)\n', '*  OR\n', '*  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether \n', '*      transaction), and only after that, deposit the amount that you want to reinvest.\n', '*  \n', '* RECOMMENDED GAS LIMIT: 200000\n', '* RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', '* You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.\n', '*\n', '* ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you \n', '* have private keys.\n', '* \n', '* Contracts reviewed and approved by pros!\n', '* \n', '* Main contract - ETHEREUM DISTRIBUTION.\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    return _a / _b;\n', '  }\n', '\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ETH_DISTRIBUTION {\n', '\tusing SafeMath for uint256;\n', '\n', '\taddress public constant marketingAddress = 0x2dB7088799a5594A152c8dCf05976508e4EaA3E4;\n', '\n', '\tmapping (address => uint256) deposited;\n', '\tmapping (address => uint256) withdrew;\n', '\tmapping (address => uint256) refearned;\n', '\tmapping (address => uint256) blocklock;\n', '\n', '\tuint256 public totalDepositedWei = 0;\n', '\tuint256 public totalWithdrewWei = 0;\n', '\n', '\tfunction() payable external\n', '\t{\n', '\t\tuint256 marketingPerc = msg.value.mul(15).div(100);\n', '\n', '\t\tmarketingAddress.transfer(marketingPerc);\n', '\t\t\n', '\t\tif (deposited[msg.sender] != 0)\n', '\t\t{\n', '\t\t\taddress investor = msg.sender;\n', '\t\t\tuint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);\n', '\t\t\tinvestor.transfer(depositsPercents);\n', '\n', '\t\t\twithdrew[msg.sender] += depositsPercents;\n', '\t\t\ttotalWithdrewWei = totalWithdrewWei.add(depositsPercents);\n', '\t\t}\n', '\n', '\t\taddress referrer = bytesToAddress(msg.data);\n', '\t\tuint256 refPerc = msg.value.mul(4).div(100);\n', '\t\t\n', '\t\tif (referrer > 0x0 && referrer != msg.sender)\n', '\t\t{\n', '\t\t\treferrer.transfer(refPerc);\n', '\n', '\t\t\trefearned[referrer] += refPerc;\n', '\t\t}\n', '\n', '\t\tblocklock[msg.sender] = block.number;\n', '\t\tdeposited[msg.sender] += msg.value;\n', '\n', '\t\ttotalDepositedWei = totalDepositedWei.add(msg.value);\n', '\t}\n', '\n', '\tfunction userDepositedWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn deposited[_address];\n', '    }\n', '\n', '\tfunction userWithdrewWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn withdrew[_address];\n', '    }\n', '\n', '\tfunction userDividendsWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);\n', '    }\n', '\n', '\tfunction userReferralsWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn refearned[_address];\n', '    }\n', '\n', '\tfunction bytesToAddress(bytes bys) private pure returns (address addr)\n', '\t{\n', '\t\tassembly {\n', '\t\t\taddr := mload(add(bys, 20))\n', '\t\t}\n', '\t}\n', '}']
['pragma solidity ^0.4.25;\n', '/**\n', '*\n', '* ETH CRYPTOCURRENCY DISTRIBUTION PROJECT\n', '* \n', '*  - GAIN 4% PER 24 HOURS (every 5900 blocks)\n', '*  - Life-long payments\n', '*  - The revolutionary reliability\n', '*  - Minimal contribution 0.01 eth\n', '*  - Currency and payment - ETH\n', '*  - Contribution allocation schemes:\n', '*    -- 85% payments\n', '*    -- 15% Marketing + Operating Expenses\n', '*\n', '*   ---About the Project\n', '*  Blockchain-enabled smart contracts have opened a new era of trustless relationships without \n', '*  intermediaries. This technology opens incredible financial possibilities. Our automated investment \n', '*  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be \n', "*  freely accessed online. In order to insure our investors' complete security, full control over the \n", '*  project has been transferred from the organizers to the smart contract: nobody can influence the \n', "*  system's permanent autonomous functioning.\n", '* \n', '* ---How to use:\n', '*  1. Send from ETH wallet to this smart contract address\n', '*     any amount from 0.01 ETH.\n', '*  2. Verify your transaction in the history of your application or etherscan.io, specifying the address \n', '*     of your wallet.\n', "*  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're \n", '*      spending too much on GAS)\n', '*  OR\n', '*  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether \n', '*      transaction), and only after that, deposit the amount that you want to reinvest.\n', '*  \n', '* RECOMMENDED GAS LIMIT: 200000\n', '* RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', '* You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.\n', '*\n', '* ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you \n', '* have private keys.\n', '* \n', '* Contracts reviewed and approved by pros!\n', '* \n', '* Main contract - ETHEREUM DISTRIBUTION.\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    return _a / _b;\n', '  }\n', '\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ETH_DISTRIBUTION {\n', '\tusing SafeMath for uint256;\n', '\n', '\taddress public constant marketingAddress = 0x2dB7088799a5594A152c8dCf05976508e4EaA3E4;\n', '\n', '\tmapping (address => uint256) deposited;\n', '\tmapping (address => uint256) withdrew;\n', '\tmapping (address => uint256) refearned;\n', '\tmapping (address => uint256) blocklock;\n', '\n', '\tuint256 public totalDepositedWei = 0;\n', '\tuint256 public totalWithdrewWei = 0;\n', '\n', '\tfunction() payable external\n', '\t{\n', '\t\tuint256 marketingPerc = msg.value.mul(15).div(100);\n', '\n', '\t\tmarketingAddress.transfer(marketingPerc);\n', '\t\t\n', '\t\tif (deposited[msg.sender] != 0)\n', '\t\t{\n', '\t\t\taddress investor = msg.sender;\n', '\t\t\tuint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);\n', '\t\t\tinvestor.transfer(depositsPercents);\n', '\n', '\t\t\twithdrew[msg.sender] += depositsPercents;\n', '\t\t\ttotalWithdrewWei = totalWithdrewWei.add(depositsPercents);\n', '\t\t}\n', '\n', '\t\taddress referrer = bytesToAddress(msg.data);\n', '\t\tuint256 refPerc = msg.value.mul(4).div(100);\n', '\t\t\n', '\t\tif (referrer > 0x0 && referrer != msg.sender)\n', '\t\t{\n', '\t\t\treferrer.transfer(refPerc);\n', '\n', '\t\t\trefearned[referrer] += refPerc;\n', '\t\t}\n', '\n', '\t\tblocklock[msg.sender] = block.number;\n', '\t\tdeposited[msg.sender] += msg.value;\n', '\n', '\t\ttotalDepositedWei = totalDepositedWei.add(msg.value);\n', '\t}\n', '\n', '\tfunction userDepositedWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn deposited[_address];\n', '    }\n', '\n', '\tfunction userWithdrewWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn withdrew[_address];\n', '    }\n', '\n', '\tfunction userDividendsWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);\n', '    }\n', '\n', '\tfunction userReferralsWei(address _address) public view returns (uint256)\n', '\t{\n', '\t\treturn refearned[_address];\n', '    }\n', '\n', '\tfunction bytesToAddress(bytes bys) private pure returns (address addr)\n', '\t{\n', '\t\tassembly {\n', '\t\t\taddr := mload(add(bys, 20))\n', '\t\t}\n', '\t}\n', '}']
