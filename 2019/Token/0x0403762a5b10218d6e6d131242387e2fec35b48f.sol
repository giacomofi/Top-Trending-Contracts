['pragma solidity ^0.5.4;\n', '\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '    \n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '    \n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '   \n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0);\n', '    uint256 c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract HolographicMediaCard is Ownable, SafeMath{\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    constructor()  public  {\n', '        balanceOf[msg.sender] = 1500000000000000000000000000;\n', '        totalSupply = 1500000000000000000000000000;\n', '        name = "Holographic Media Card";\n', '        symbol = "HMC";\n', '        decimals = 18;\n', '\t\t\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\t\trequire(_value > 0); \n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\t\tuint previousBalances = balanceOf[msg.sender] + balanceOf[_to];\t\t\n', '        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\t\tassert(balanceOf[msg.sender]+balanceOf[_to]==previousBalances);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '\t\trequire((_value == 0) || (allowance[msg.sender][_spender] == 0));\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require (_to != address(0));\n', '\t\trequire (_value > 0); \n', '        require (balanceOf[_from] >= _value) ;\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '        require (_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);\n', '        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);\n', '        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}']