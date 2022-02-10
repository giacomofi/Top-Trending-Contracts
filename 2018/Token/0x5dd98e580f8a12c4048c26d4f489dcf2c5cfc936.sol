['/*! Smartcontract Token | (c) 2018 BelovITLab LLC | License: MIT */\n', '//\n', '//                                     _\n', '//                                _.-~~.)              SMARTCONTRACT.RU\n', "//          _.--~~~~~---....__  .' . .,'          \n", "//        ,'. . . . . . . . . .~- ._ (                 Development smart-contracts\n", "//       ( .. .g. . . . . . . . . . .~-._              Investor's office for ICO\n", '//    .~__.-~    ~`. . . . . . . . . . . -.\n', '//    `----..._      ~-=~~-. . . . . . . . ~-.         Telegram: https://goo.gl/FRP4nz    \n', '//              ~-._   `-._ ~=_~~--. . . . . .~.\n', '//               | .~-.._  ~--._-.    ~-. . . . ~-.\n', "//                \\ .(   ~~--.._~'       `. . . . .~-.                ,\n", "//                 `._\\         ~~--.._    `. . . . . ~-.    .- .   ,'/\n", "// _  . _ . -~\\        _ ..  _          ~~--.`_. . . . . ~-_     ,-','`  .\n", "//              ` ._           ~                ~--. . . . .~=.-'. /. `\n", '//        - . -~            -. _ . - ~ - _   - ~     ~--..__~ _,. /   \\  - ~\n', '//               . __ ..                   ~-               ~~_. (  `\n', '// )`. _ _               `-       ..  - .    . - ~ ~ .    \\    ~-` ` `  `. _\n', '//                                                     - .  `  .   \\  \\ `.\n', '\n', '\n', 'pragma solidity 0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() { require(msg.sender == owner); _; }\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        owner = newOwner;\n', '        OwnershipTransferred(owner, newOwner);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    bool public paused = false;\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() { require(!paused); _; }\n', '    modifier whenPaused() { require(paused); _; }\n', '\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) public view returns(uint256);\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '}\n', '\n', 'contract StandardToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function StandardToken(string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '    \n', '    function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {\n', '        require(_to.length == _value.length);\n', '\n', '        for(uint i = 0; i < _to.length; i++) {\n', '            transfer(_to[i], _value[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '\n', '        if(_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() { require(!mintingFinished); _; }\n', '    modifier notMint() { require(mintingFinished); _; }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '\n', '        Mint(_to, _amount);\n', '        Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() onlyOwner canMint public returns(bool) {\n', '        mintingFinished = true;\n', '\n', '        MintFinished();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CappedToken is MintableToken {\n', '    uint256 public cap;\n', '\n', '    function CappedToken(uint256 _cap) public {\n', '        require(_cap > 0);\n', '        cap = _cap;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {\n', '        require(totalSupply.add(_amount) <= cap);\n', '\n', '        return super.mint(_to, _amount);\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        address burner = msg.sender;\n', '\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '/* This is your discount for development smartcontract 5% */\n', '/* For order smart-contract please contact at Telegram: https://t.me/joinchat/Bft2vxACXWjuxw8jH15G6w */\n', '\n', "/* We develop inverstor's office for ICO, operator's dashboard for ICO, Token Air Drop  */\n", '/* info@smartcontract.ru */\n', '\n', 'contract Token is CappedToken, BurnableToken {\n', '\n', '    string public URL = "http://smartcontract.ru";\n', '\n', '    function Token() CappedToken(100000000 * 1 ether) StandardToken("SMARTCONTRACT.RU", "SMART", 18) public {\n', '        \n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns(bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '    \n', '    function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {\n', '        return super.multiTransfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '}']