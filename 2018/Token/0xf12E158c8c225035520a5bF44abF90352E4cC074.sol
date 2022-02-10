['// Solydity version\n', 'pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    address public icoOwner;\n', '    address public burnerOwner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner || msg.sender == icoOwner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyBurner() {\n', '      require(msg.sender == owner || msg.sender == burnerOwner);\n', '      _;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public;\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// initialization contract\n', 'contract StepCoin is ERC20Interface, Ownable{\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "StepCoin";\n', '\n', '    string public constant symbol = "STEP";\n', '\n', '    uint8 public constant decimals = 3;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '     \n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    // Function initialization of contract\n', '    function StepCoin() {\n', '\n', '        totalSupply_ = 100000000 * (10 ** uint256(decimals));\n', '\n', '        balances[msg.sender] = totalSupply_;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        \n', '        allowed[_from][_to] = allowed[_from][msg.sender].sub(_value);\n', '        \n', '        _transfer(_from, _to, _value);\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint256 _value) internal returns (bool){\n', '        require(_to != 0x0);\n', '        require(_value <= balances[_from]);\n', '        require(balances[_to].add(_value) >= balances[_to]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferOwner(address _from, address _to, uint256 _value) onlyOwner public {\n', '        _transfer(_from, _to, _value);\n', '    }\n', '\n', '    function setIcoOwner(address _addressIcoOwner) onlyOwner external {\n', '        icoOwner = _addressIcoOwner;\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner onlyBurner public {\n', '      _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) onlyOwner onlyBurner internal {\n', '      require(_value <= balances[_who]);\n', '\n', '      balances[_who] = balances[_who].sub(_value);\n', '      totalSupply_ = totalSupply_.sub(_value);\n', '      Burn(_who, _value);\n', '      Transfer(_who, address(0), _value);\n', '  }\n', '\n', '    function setBurnerOwner(address _addressBurnerOwner) onlyOwner external {\n', '        burnerOwner = _addressBurnerOwner;\n', '    }\n', '}']