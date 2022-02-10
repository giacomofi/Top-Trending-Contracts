['/*\n', '****************************\n', '****************************\n', 'BETVIBE token contract\n', '****************************\n', '****************************\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BETVIBE is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    address public owner;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;    \n', '\n', '    string public constant name = "BETVIBE TOKEN";\n', '    string public constant symbol = "VIBET";\n', '    uint public constant decimals = 8;\n', '    \n', '    uint256 public maxSupply = 12000000000e8;\n', '    uint256 public constant minContrib = 1 ether / 100;\n', '    uint256 public VIBETPerEther = 20000000e8;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burn(address indexed burner, uint256 value);\n', '    constructor () public {\n', '        totalSupply = maxSupply;\n', '        balances[msg.sender] = maxSupply;\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function () public payable {\n', '        buyVIBET();\n', '     }\n', '    \n', '    function buyVIBET() payable public {\n', '        address investor = msg.sender;\n', '        uint256 tokenAmt =  VIBETPerEther.mul(msg.value) / 1 ether;\n', '        require(msg.value >= minContrib && msg.value > 0);\n', '        require(balances[owner] >= tokenAmt);\n', '        balances[owner] -= tokenAmt;\n', '        balances[investor] += tokenAmt;\n', '        owner.transfer(msg.value);\n', '        emit Transfer(this, investor, tokenAmt);   \n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    //mitigates the ERC20 short address attack\n', '    //suggested by izqui9 @ http://bit.ly/2NMMCNv\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[_from]);\n', '        require(_amount <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) constant public returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function transferOwnership(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '    \n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '    \n', '}']