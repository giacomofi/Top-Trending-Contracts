['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-02\n', '*/\n', '\n', '// "SPDX-License-Identifier: UNLICENSED"\n', '\n', 'pragma solidity 0.7.4;\n', '\n', 'contract TestX {\n', '\n', 'using SafeMath for uint256;\n', '\n', 'string public constant symbol = "TestX";\n', 'string public constant name = "Tester X";\n', 'uint8 public constant decimals = 16;\n', '\n', 'uint256 _totalSupply;\n', 'address owner;\n', '\n', 'mapping(address => uint256) balances;\n', 'mapping(address => mapping (address => uint256)) allowances;\n', '\n', '//Data\n', '    string public companyName;\n', '    uint256 public assetsTransactionCount;\n', '\n', '    mapping(uint => _assetsTransaction) public assetsTransaction;\n', '\n', '    struct _assetsTransaction {\n', '        uint _id;\n', '        \n', '        string _dateTime;\n', '        string _action;\n', '        string _description;\n', '        string _transactionValue;\n', '        string _newGoodwill;\n', '   }\n', 'constructor() {\n', '    \n', '    owner = msg.sender;\n', '    _totalSupply = 1000000000 * 10 ** uint256(decimals);\n', '    balances[owner] = _totalSupply;\n', '    \n', '    companyName = "Test AG";\n', '    assetsTransactionCount = 0;\n', '    assetsTransaction[0] = _assetsTransaction(0, "", "", "", "", "");\n', '    \n', '    emit Transfer(address(0), owner, _totalSupply);\n', '}\n', 'function totalSupply() public view returns (uint256) {\n', '   return _totalSupply;\n', '}\n', 'function getOwner() public view returns (address) {\n', '   return owner;\n', '}\n', 'function balanceOf(address account) public view returns (uint256 balance) {\n', '   return balances[account];\n', '}\n', 'function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '    require(msg.sender != address(0), "ERC20: approve from the zero address");\n', '    require(_to != address(0), "ERC20: approve from the zero address");\n', '    require(balances[msg.sender] >= _amount);\n', '    balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(msg.sender, _to, _amount);\n', '    return true;\n', '}\n', 'function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '    require(_from != address(0), "ERC20: approve from the zero address");\n', '    require(_to != address(0), "ERC20: approve from the zero address");\n', '    require(balances[_from] >= _amount && allowances[_from][msg.sender] >= _amount);\n', '    balances[_from] = balances[_from].sub(_amount);\n', '    allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    emit Transfer(_from, _to, _amount);\n', '    return true;\n', '}\n', 'function approve(address spender, uint256 _amount) public returns (bool) {\n', '    _approve(msg.sender, spender, _amount);\n', '    return true;\n', '}\n', 'function _approve(address _owner, address _spender, uint256 _amount) internal {\n', '    require(_owner != address(0), "ERC20: approve from the zero address");\n', '    require(_spender != address(0), "ERC20: approve to the zero address");\n', '    allowances[_owner][_spender] = _amount;\n', '    emit Approval(_owner, _spender, _amount);\n', '    }\n', 'function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '   return allowances[_owner][_spender];\n', '}\n', '\n', 'function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    _approve(msg.sender, spender, allowances[msg.sender][spender].sub(subtractedValue));\n', '    return true;\n', '}\n', 'function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '        _approve(msg.sender, spender, allowances[msg.sender][spender].add(addedValue));\n', '        return true;\n', '}\n', 'function burn(uint256 _amount) public returns (bool success) {\n', '    require(_amount > 0, "ERC20: amount must be greater than zero");\n', '    require(msg.sender == owner, "ERC20: only the owner can mint/generate new tokens");\n', '    require(balances[owner] >= _amount,"ERC20: not enough tokens available");\n', ' \n', '    _totalSupply = _totalSupply.sub(_amount);\n', '    balances[owner] = balances[owner].sub(_amount);\n', '\n', '    emit Burned(owner, _amount);\n', '    emit Transfer(owner, address(0), _amount);\n', '   \n', '   return true;\n', '}\n', 'function addAssetsTransaction(string calldata _dateTime, string calldata _action,\n', '                              string calldata _description, string calldata _transactionValue,\n', '                              string calldata _newGoodwill) external {\n', '    require(msg.sender == owner, "ERC20: only the owner can add Assets");\n', '    assetsTransactionCount += 1;\n', '    assetsTransaction[assetsTransactionCount] = \n', '        _assetsTransaction(assetsTransactionCount, _dateTime, _action, _description, _transactionValue, _newGoodwill);\n', '}\n', 'function setCompanyName(string calldata _companyName) external {\n', '        require(msg.sender == owner, "ERC20: only the owner can add Assets");\n', '    companyName = _companyName;\n', '}\n', '\n', 'event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', 'event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', 'event Minted(address indexed _owner, uint256 _value);\n', 'event Burned(address indexed _owner, uint256 _value);\n', '\n', '}\n', '\n', 'library SafeMath {\n', '    \n', 'function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a, "SafeMath: addition overflow");\n', '    return c;\n', '}\n', 'function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a, "SafeMath: subtraction overflow");\n', '    uint256 c = a - b;\n', '    return c;\n', '}\n', '}']