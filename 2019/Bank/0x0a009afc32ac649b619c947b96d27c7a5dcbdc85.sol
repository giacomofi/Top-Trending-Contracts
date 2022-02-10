['pragma solidity ^0.5.9;\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface Qobit {\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '}\n', '\n', '// THIS IS the Smart Contract for QOBIT FAMILY PLAN (QFP), QOB and Erc20-USDT Pool transfer for buyers.\n', 'contract SendBonus is SafeMath, Owned {\n', '    Qobit public token;\n', '    event BonusSent(address user, uint256 amount);\n', '\n', '    constructor(address _addressOfToken) public {\n', '        token = Qobit(_addressOfToken);\n', '    }\n', '\n', '    function sendToken(address[] memory dests, uint256[] memory values) onlyOwner public returns(bool success) {\n', '        require(dests.length > 0);\n', '        require(dests.length == values.length);\n', '\n', '        // calculate total amount\n', '        uint256 totalAmount = 0;\n', '        for (uint i = 0; i < values.length; i++) {\n', '            totalAmount = add(totalAmount, values[i]);\n', '        }\n', '\n', '        require(totalAmount > 0, "total amount must > 0");\n', '        require(totalAmount < token.balanceOf(address(this)), "total amount must < this address token balance ");\n', '\n', '        for (uint j = 0; j < dests.length; j++) {\n', '            token.transfer(dests[j], values[j]); // mul decimal\n', '            emit BonusSent(dests[j], values[j]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '}']