['/**\n', ' * Website: www.SafeInvest.co\n', ' *\n', ' * RECOMMENDED GAS LIMIT: 200000\n', ' * RECOMMENDED GAS PRICE: https://ethgasstation.info/\n', ' */\n', '\n', 'pragma solidity 0.4.25;\n', '\n', '\n', 'library SafeMath {\n', '\n', '\n', '    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        if (_a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = _a * _b;\n', '        require(c / _a == _b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b > 0);\n', '        uint256 c = _a / _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        require(_b <= _a);\n', '        uint256 c = _a - _b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '        uint256 c = _a + _b;\n', '        require(c >= _a);\n', '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract SafeInvest {\n', '    \n', '\tusing SafeMath for uint;\n', '\n', '    address public owner;\n', '    address marketing = 0x906Bd47Fcf07F82B98F28d1e572cA8D2273AA7CD;\n', '    address admin = 0xe0C507cd978F380eac44eDf22Ea734B6c16B5fCF;\n', '\n', '    mapping (address => uint) deposit;\n', '    mapping (address => uint) checkpoint;\n', '    mapping (address => bool) commission; \n', '\n', '    mapping (address => address) referrers;\n', '\n', '    event LogInvestment(address indexed _addr, uint _value);\n', '    event LogPayment(address indexed _addr, uint _value);\n', '\tevent LogReferralPayment(address indexed _referral, address indexed _referrer, uint _value);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function renounceOwnership() external {\n', '        require(msg.sender == owner);\n', '        owner = 0x0;\n', '    }\n', '\n', '    function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {\n', '        assembly {\n', '            parsedreferrer := mload(add(_source,0x14))\n', '        }\n', '        return parsedreferrer;\n', '    }\n', '\n', '    function() external payable {\n', '        if (msg.value >= 0 && msg.value < 0.0000002 ether) {\n', '            withdraw(0);\n', '        } \n', '\t\telse if (msg.value == 0.0000002 ether){\n', '            moneyBack();\n', '        } \n', '\t\telse {\n', '            invest();\n', '        }\t\t\n', '    }\n', '\t\n', '    function invest() public payable {\n', '        require(msg.value >= 0.01 ether);\n', '\t\t\n', '        if (deposit[msg.sender] > 0) {\n', '            withdraw(msg.value);\n', '        }\n', '\t\t\n', '        if (msg.data.length == 20) {\n', '            address _referrer = bytesToAddress(bytes(msg.data));\n', '\t\t\tif (_referrer != msg.sender) {\n', '\t\t\t\treferrers[msg.sender] = _referrer;\n', '\t\t\t}\n', '        }\t\t\n', '\t\t\n', '\t\tcheckpoint[msg.sender] = block.timestamp;\n', '\t\tdeposit[msg.sender] = deposit[msg.sender].add(msg.value);\n', '\t\t\n', '\t\temit LogInvestment(msg.sender, msg.value);\n', '\t}\t\t\n', '\n', '    function withdraw(uint _msgValue) internal {\n', '\t\tif (!commission[msg.sender]) {\n', '\t\t\tfirstWithdraw(deposit[msg.sender]+_msgValue);\n', '\t\t} else if (_msgValue > 0) {\n', '\t\t\tpayCommissions(_msgValue);\n', '\t\t}\n', '\t\t\n', '        uint _payout = getPayout(msg.sender);\n', '\n', '        if (_payout > 0) {\n', '            msg.sender.transfer(_payout);\n', '            emit LogPayment(msg.sender, _payout);\n', '        }\n', '\t\t\n', '\t\tcheckpoint[msg.sender] = block.timestamp;\n', '    }\n', '\t\n', '\tfunction firstWithdraw(uint _deposit) internal {\t\n', '\t\tcommission[msg.sender] = true;\n', '\t\tpayCommissions(_deposit);\n', '\t}\n', '\t\n', '\tfunction moneyBack() internal {\n', '\t\trequire(!commission[msg.sender]);\n', '\t\trequire(deposit[msg.sender] > 0);\n', '\t\trequire((block.timestamp.sub(checkpoint[msg.sender])).div(1 days) < 7);\n', '\t\t\n', '\t\tmsg.sender.transfer(deposit[msg.sender]);\n', '\t\t\n', '\t\tdeposit[msg.sender] = 0;\n', '\t\tcommission[msg.sender] = false;\n', '\t}\n', '\n', '\tfunction payCommissions(uint _deposit) internal {\t\n', '\t\tuint _admFee = _deposit.mul(3).div(100); \n', '\t\tuint _marketingFee = _deposit.div(10); \n', '        if (referrers[msg.sender] > 0) {\n', '\t\t\tuint _refFee = _deposit.mul(5).div(100);\n', '\t\t\treferrers[msg.sender].transfer(_refFee);\n', '\t\t\temit LogReferralPayment(msg.sender, referrers[msg.sender], _refFee);\n', '\t\t}\n', '\t\t\n', '\t\tadmin.transfer(_admFee);\n', '\t\tmarketing.transfer(_marketingFee);\n', '\t}\n', '\t\t\n', '    function getPayout(address _address) public view returns(uint) {\n', '\t\tuint rate = getInterest(_address);\n', '\t\treturn (deposit[_address].mul(rate).div(100)).mul(block.timestamp.sub(checkpoint[_address])).div(1 days);\n', '    }\n', '\t\n', '    function getInterest(address _address) internal view returns(uint) {\n', '        if (deposit[_address]<= 3 ether) {\n', '            return 4; \n', '        } else if (deposit[_address] <= 6 ether) {\n', '            return 5; \n', '        } else {\n', '            return 6; \n', '        }\n', '    }\t\n', '\n', '\n', '}']