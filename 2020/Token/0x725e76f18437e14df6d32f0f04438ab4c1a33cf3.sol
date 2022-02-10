['pragma solidity ^0.5.8;\n', '\n', '\n', 'contract DeFigemToken {\n', '   \n', '    string public constant name = "DeFiGem";\n', '\n', '    string public constant symbol = "DGEM";\n', '\n', '    uint8 public constant decimals = 18;\n', '\n', '    // Contract owner will be your Link account\n', '    address public owner;\n', '\n', '    address public treasury;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    mapping (address => uint256) private balances;\n', '\n', '    event Approval(address indexed tokenholder, address indexed spender, uint256 value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        treasury = address(0x87d0F73673b83e2f073064BAD1E9d309AF943Db1);\n', '        totalSupply = 210000 * 10**uint(decimals);\n', '\n', '        balances[treasury] = totalSupply;\n', '        emit Transfer(address(0), treasury, totalSupply);\n', '    }\n', '\n', '    function () external payable {\n', '        revert();\n', '    }\n', '\n', '    function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_tokenholder][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(_spender != address(0));\n', '        require(_spender != msg.sender);\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _tokenholder) public view returns (uint256 balance) {\n', '        return balances[_tokenholder];\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {\n', '        require(_spender != address(0));\n', '        require(_spender != msg.sender);\n', '\n', '        if (allowed[msg.sender][_spender] <= _subtractedValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {\n', '        require(_spender != address(0));\n', '        require(_spender != msg.sender);\n', '        require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);\n', '\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != msg.sender);\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(balances[msg.sender] - _value <= balances[msg.sender]);\n', '        require(balances[_to] <= balances[_to] + _value);\n', '        require(_value <= transferableTokens(msg.sender));\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_from != address(0));\n', '        require(_from != address(this));\n', '        require(_to != _from);\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        require(_value <= transferableTokens(_from));\n', '        require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);\n', '        require(balances[_from] - _value <= balances[_from]);\n', '        require(balances[_to] <= balances[_to] + _value);\n', '\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        balances[_from] = balances[_from] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public {\n', '        require(msg.sender == owner);\n', '        require(_newOwner != address(0));\n', '        require(_newOwner != address(this));\n', '        require(_newOwner != owner);\n', '\n', '        address previousOwner = owner;\n', '        owner = _newOwner;\n', '\n', '        emit OwnershipTransferred(previousOwner, _newOwner);\n', '    }\n', '\n', '    function transferableTokens(address holder) public view returns (uint256) {\n', '        return balanceOf(holder);\n', '    }\n', '}']