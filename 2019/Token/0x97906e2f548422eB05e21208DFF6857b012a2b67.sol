['contract Hermes {\n', '    \n', '    string public constant name = "↓ See Code Of The Contract ↓";\n', '    \n', '    string public constant symbol = "Code ✓✓✓";\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    address owner;\n', '    \n', '    uint public index;\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function() public payable {}\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    \n', '    function resetIndex(uint _n) public onlyOwner {\n', '        index = _n;\n', '    }\n', '    \n', '    function massSending(address[]  _addresses) external onlyOwner {\n', '        for (uint i = 0; i < _addresses.length; i++) {\n', '            _addresses[i].send(777);\n', '            emit Transfer(0x0, _addresses[i], 777);\n', '        }\n', '    }\n', '    \n', '    function withdrawBalance() public onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}']