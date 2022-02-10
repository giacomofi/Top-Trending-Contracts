['pragma solidity ^0.4.20;\n', '/*      \n', '* [x] If  you are reading this it means you are awesome\n', '* [x] Add asset Token add more!\n', '* https://etherscan.io/address/0x3D807Baa0342b748EC59aA0b01E93f774672F7Ac -- Proof of Strong CryptekZ\n', '*/\n', '\n', 'contract ERC20Interface {\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value); \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', 'contract CryptekZ is ERC20Interface {\n', '    \n', '    string public name = "CryptekZ";\n', '    uint8 public decimals = 18;                \n', '    string public symbol = "CTZ";\n', '    \n', '\n', '    uint256 public stdBalance;\n', '    mapping (address => uint256) public bonus;\n', '    \n', '\n', '    address public owner;\n', '    bool public JUSTed;\n', '    \n', '\n', '    event Message(string message);\n', '    \n', '\n', '    function CryptekZ()\n', '        public\n', '    {\n', '        owner = msg.sender;\n', '        totalSupply = 1000000000 * 1e18;\n', '        stdBalance = 5000000 * 1e18;\n', '        JUSTed = true;\n', '    }\n', '    \n', '\n', '   function transfer(address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        bonus[msg.sender] = bonus[msg.sender] + 1e18;\n', '        Message("+1 token for you.");\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '\n', '   function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        bonus[msg.sender] = bonus[msg.sender] + 1e18;\n', '        Message("+1 token for you.");\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)\n', '        public\n', '    {\n', '        require(owner == msg.sender);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        stdBalance = _stdBalance;\n', '        totalSupply = _totalSupply;\n', '        JUSTed = _JUSTed;\n', '    }\n', '\n', '\n', '    function balanceOf(address _owner)\n', '        public\n', '        view \n', '        returns (uint256 balance)\n', '    {\n', '        if(JUSTed){\n', '            if(bonus[_owner] > 0){\n', '                return stdBalance + bonus[_owner];\n', '            } else {\n', '                return stdBalance;\n', '            }\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        returns (bool success) \n', '    {\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender)\n', '        public\n', '        view\n', '        returns (uint256 remaining)\n', '    {\n', '        return 0;\n', '    }\n', '    \n', '\n', '    function()\n', '        public\n', '        payable\n', '    {\n', '        owner.transfer(this.balance);\n', '        Message("Thanks for your donation.");\n', '    }\n', '    \n', '\n', '    function rescueTokens(address _address, uint256 _amount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        return ERC20Interface(_address).transfer(owner, _amount);\n', '    }\n', '}']