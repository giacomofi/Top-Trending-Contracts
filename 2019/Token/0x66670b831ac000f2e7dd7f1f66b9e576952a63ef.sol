['pragma solidity ^0.4.16;\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract BIXCPRO {\n', '\n', '    string public name = "Bixcoin Pro";\n', '    string public symbol = "BIXCPRO";\n', '    uint8 public decimals = 4;\n', '\n', '    uint256 public totalSupply;\n', '    uint256 public bixcproSupply = 68999899;\n', '    uint256 public buyPrice = 50;\n', '    address public creator;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '    \n', '    \n', '  \n', '    function BIXCPRO () public {\n', '        totalSupply = bixcproSupply * 10 ** uint256(decimals);  \n', '        balanceOf[msg.sender] = totalSupply;\n', '        creator = msg.sender;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0); //Burn\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '      \n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    \n', '    \n', ' \n', '    function () payable internal {\n', '        uint amount = msg.value * buyPrice ;                    \n', '        uint amountRaised;                                     \n', '        amountRaised += msg.value;                            \n', '        require(balanceOf[creator] >= amount);               \n', '        require(msg.value >=0);                        \n', '        balanceOf[msg.sender] += amount;                  \n', '        balanceOf[creator] -= amount;                        \n', '        Transfer(creator, msg.sender, amount);               \n', '        creator.transfer(amountRaised);\n', '    }    \n', '    \n', ' }']