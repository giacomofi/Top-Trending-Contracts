['/**\n', ' *Submitted for verification at Etherscan.io on 2020-09-24\n', '*/\n', '\n', 'pragma solidity ^0.5.1;\n', '\n', '\n', '/*\n', '    * PolkaShare contract is ERC20 with PolkaDot and Moonbeam swap compatibility.\n', '*/\n', '\n', 'interface ERC20 {\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function allowance(address _owner, address _spender) external view returns (uint256);\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '    function approve(address _spender, uint256 _value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/*\n', '    * SafeMath\n', '    \n', '*/\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/*\n', '    * Swap logic to Moonbeam PolkaDot 1:1 swap\n', '    \n', '        Create ERC20 Contract in code below with PolkaDot and Moonbeam contract compatibility.\n', '        \n', '*/\n', 'contract PolkaShare is ERC20 {\n', '    using SafeMath for uint256;\n', '    address private deployer;\n', '    string public name = "PolkaShare";\n', '    string public symbol = "SHARE";\n', '    uint8 public constant decimals = 18;\n', '    uint256 private constant decimalFactor = 10 ** uint256(decimals);\n', '    uint256 public constant startingSupply = 200000 * decimalFactor;\n', '    uint256 public burntTokens = 0;\n', '    bool public minted = false;\n', '    bool public unlocked = false;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    modifier onlyOwner() {\n', '        require(deployer == msg.sender, "Caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        deployer = msg.sender;\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return deployer;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        uint256 currentTokens = startingSupply.sub(burntTokens);\n', '        return currentTokens;\n', '    }\n', '    \n', '    function mint(address _owner) public onlyOwner returns (bool) {\n', '        require(minted != true, "Tokens already minted");\n', '        balances[_owner] = startingSupply;\n', '        emit Transfer(address(0), _owner, startingSupply);\n', '        minted = true;\n', '        return true;\n', '    }\n', '    \n', '    function unlockTokens() public onlyOwner returns (bool) {\n', '        require(unlocked != true, "Tokens already unlocked");\n', '        unlocked = true;\n', '        return true;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function _burn(address account, uint256 amount) internal {\n', '        require(account != address(0));\n', '        balances[account] = balances[account].sub(amount);\n', '        burntTokens = burntTokens.add(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(unlocked == true, "Tokens not unlocked yet");\n', '        uint256 tokensToBurn = _value.div(100);\n', '        uint256 tokensToSend = _value.sub(tokensToBurn);\n', '        balances[msg.sender] = balances[msg.sender].sub(tokensToSend);\n', '        _burn(msg.sender, tokensToBurn);\n', '        balances[_to] = balances[_to].add(tokensToSend);\n', '        \n', '        emit Transfer(msg.sender, _to, tokensToSend);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(unlocked == true, "Tokens not unlocked yet");\n', '        uint256 tokensToBurn = _value.div(100);\n', '        uint256 tokensToSend = _value.sub(tokensToBurn);\n', '        balances[_from] = balances[_from].sub(tokensToSend);\n', '        balances[_to] = balances[_to].add(tokensToSend);\n', '        _burn(_from, tokensToBurn);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, tokensToSend);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}']