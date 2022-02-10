['pragma solidity ^0.4.18;\n', '\n', 'contract BBTDonate {\n', '\n', '    address public owner;\n', '    bool public isClosed;\n', '    uint256 public totalReceive;\n', '    uint256 public remain;\n', '    mapping (address => uint256) public record;\n', '    mapping (address => bool) public isAdmin;\n', '\n', '    modifier onlyAdmin {\n', '        require(msg.sender == owner || isAdmin[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    function BBTDonate() public {\n', '        owner = msg.sender;\n', '        totalReceive = 0;\n', '        isClosed = false;\n', '    }\n', '    \n', '    function () payable public {\n', '        record[msg.sender] = add(record[msg.sender], msg.value);\n', '        totalReceive = add(totalReceive, msg.value);\n', '    }\n', '    \n', '    function refund(address thankyouverymuch) public {\n', '        require(isClosed);\n', '        require(record[thankyouverymuch] != 0);\n', '        uint256 amount = div(mul(remain, record[thankyouverymuch]), totalReceive);\n', '        record[thankyouverymuch] = 0;\n', '        require(thankyouverymuch.send(amount));\n', '    }\n', '    \n', '    // only admin\n', '    function dispatch (address _receiver, uint256 _amount, string log) onlyAdmin public {\n', '        require(bytes(log).length != 0);\n', '        require(_receiver.send(_amount));\n', '    }\n', '    \n', '\n', '    // only owner\n', '    function changeOwner (address _owner) onlyOwner public {\n', '        owner = _owner;\n', '    }\n', '    \n', '    function addAdmin (address _admin, bool remove) onlyOwner public {\n', '        if(remove) {\n', '            isAdmin[_admin] = false;\n', '        }\n', '        isAdmin[_admin] = true;\n', '    }\n', '    \n', '    function turnOff () onlyOwner public {\n', '        isClosed = true;\n', '        remain = this.balance;\n', '    }\n', '    \n', '    function collectBalance () onlyOwner public {\n', '        require(isClosed);\n', '        require(owner.send(this.balance));\n', '    }\n', '    \n', '    // helper function\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    } \n', '    \n', '\n', '}']