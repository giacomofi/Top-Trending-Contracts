['pragma solidity ^0.4.24;\n', '\n', 'contract ConferencePay {\n', '    uint public endTime;\n', '    address public owner;\n', '    mapping (bytes32 => uint) public talkMapping;\n', '    using SafeMath for uint256;\n', '\n', '    struct Talk {\n', '        uint amount;\n', '        address addr;\n', '        bytes32 title;\n', '    }\n', '\n', '    Talk[] public talks;\n', '\n', '    modifier onlyBefore(uint _time) { require(now < _time); _; }\n', '    modifier onlyAfter(uint _time) { require(now > _time); _; }\n', '\n', '\t//event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\n', '\tconstructor(uint end) public {\n', '        endTime = end;\n', '        owner = msg.sender;\n', '\t}\n', '\n', '    function getTalkCount() public constant returns(uint) {\n', '        return talks.length;\n', '    }\n', '\n', '    function add(address addr, bytes32 title) public returns(uint) {\n', '        uint index = talks.length;\n', '        talkMapping[title] = index;\n', '        talks.push(Talk({\n', '            amount: 0,\n', '            addr: addr,\n', '            title: title\n', '        }));\n', '        return index;\n', '    }\n', '\n', '\tfunction pay(uint talk) public payable returns(bool sufficient) {\n', '\t\ttalks[talk].amount += msg.value;\n', '\t\treturn true;\n', '\t}\n', '\n', '    function end() public {\n', '        require(now > endTime);\n', '        uint max = 0;\n', '        address winnerAddress;\n', '        uint balance = address(this).balance;\n', '        owner.transfer(balance.mul(20).div(100));\n', '        for (uint i = 0; i < talks.length; i++) {\n', '            if (talks[i].amount > max) {\n', '                max = talks[i].amount;\n', '                winnerAddress = talks[i].addr;\n', '            }\n', '            talks[i].addr.transfer(talks[i].amount.mul(70).div(100));\n', '        }\n', '        winnerAddress.transfer(address(this).balance);\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']