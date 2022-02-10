['pragma solidity ^0.7.2;\n', '\n', 'contract Owned {\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    address owner;\n', '    address newOwner;\n', '    function changeOwner(address payable _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    mapping (address=>uint256) balances;\n', '    mapping (address=>mapping (address=>uint256)) allowed;\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    function balanceOf(address _owner) view public returns (uint256 balance) {return balances[_owner];}\n', '    \n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '        balances[msg.sender]-=_amount;\n', '        balances[_to]+=_amount;\n', '        emit Transfer(msg.sender,_to,_amount);\n', '        return true;\n', '    }\n', '  \n', '    function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {\n', '        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '        balances[_from]-=_amount;\n', '        allowed[_from][msg.sender]-=_amount;\n', '        balances[_to]+=_amount;\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        allowed[msg.sender][_spender]=_amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract MIKI is Owned,ERC20{\n', '    uint256 public maxSupply;\n', '\n', '    constructor(address _owner) {\n', '        symbol = "MIKI";\n', '        name = "MIKI Finance";\n', '        decimals = 18;                                 // 18 Decimals are Best for Liquidity\n', '        totalSupply = 10000000000000000000000;           // 10000 is Total Supply ; Rest 18 Zeros are Decimals\n', '        maxSupply   = 10000000000000000000000;           // 10000 is Total Supply ; Rest 18 Zeros are Decimals\n', '        owner = _owner;\n', '        balances[owner] = totalSupply;\n', '    }\n', '    \n', '    receive() external payable {\n', '        revert();\n', '    }\n', '    \n', '   \n', '}']