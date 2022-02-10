['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract MintableToken {\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 is Ownable, MintableToken {\n', '    using SafeMath for uint;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    address public owner;\n', '    uint256 public totalSupply;\n', '    bool public isEnabled = true;\n', '\n', '    mapping (address => bool) public saleAgents;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    function TokenERC20(string _tokenName, string _tokenSymbol) public {\n', '        name = _tokenName; // Записываем название токена\n', '        symbol = _tokenSymbol; // Записываем символ токена\n', '        owner = msg.sender; // Делаем создателя контракта владельцем\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != 0x0);\n', '        require(_value <= balanceOf[_from]);\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        require(isEnabled);\n', '\n', '        uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '         _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '          allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) canMint public returns (bool) {\n', '        require(msg.sender == owner || saleAgents[msg.sender]);\n', '        totalSupply = totalSupply.add(_amount);\n', '        balanceOf[_to] = balanceOf[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        uint256 ownerTokens = totalSupply.mul(2).div(3); // 60% * 2 / 3 = 40%\n', '        mint(owner, ownerTokens);\n', '\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool) {\n', '        require(balanceOf[msg.sender] >= _value);   // Проверяем, достаточно ли средств у сжигателя\n', '\n', '        address burner = msg.sender;\n', '        balanceOf[burner] = balanceOf[burner].sub(_value);  // Списываем с баланса сжигателя\n', '        totalSupply = totalSupply.sub(_value);  // Обновляем общее количество токенов\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0x0), _value);\n', '        return true;\n', '    }\n', '\n', '    function addSaleAgent (address _saleAgent) public onlyOwner {\n', '        saleAgents[_saleAgent] = true;\n', '    }\n', '\n', '    function disable () public onlyOwner {\n', '        require(isEnabled);\n', '        isEnabled = false;\n', '    }\n', '    function enable () public onlyOwner {\n', '        require(!isEnabled);\n', '        isEnabled = true;\n', '    }\n', '}\n', '\n', 'contract Token is TokenERC20 {\n', '    function Token() public TokenERC20("Ideal Digital Memory", "IDM") {}\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract MintableToken {\n', '    bool public mintingFinished = false;\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract TokenERC20 is Ownable, MintableToken {\n', '    using SafeMath for uint;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    address public owner;\n', '    uint256 public totalSupply;\n', '    bool public isEnabled = true;\n', '\n', '    mapping (address => bool) public saleAgents;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    function TokenERC20(string _tokenName, string _tokenSymbol) public {\n', '        name = _tokenName; // Записываем название токена\n', '        symbol = _tokenSymbol; // Записываем символ токена\n', '        owner = msg.sender; // Делаем создателя контракта владельцем\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != 0x0);\n', '        require(_value <= balanceOf[_from]);\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        require(isEnabled);\n', '\n', '        uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '         _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '          allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) canMint public returns (bool) {\n', '        require(msg.sender == owner || saleAgents[msg.sender]);\n', '        totalSupply = totalSupply.add(_amount);\n', '        balanceOf[_to] = balanceOf[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        uint256 ownerTokens = totalSupply.mul(2).div(3); // 60% * 2 / 3 = 40%\n', '        mint(owner, ownerTokens);\n', '\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public returns (bool) {\n', '        require(balanceOf[msg.sender] >= _value);   // Проверяем, достаточно ли средств у сжигателя\n', '\n', '        address burner = msg.sender;\n', '        balanceOf[burner] = balanceOf[burner].sub(_value);  // Списываем с баланса сжигателя\n', '        totalSupply = totalSupply.sub(_value);  // Обновляем общее количество токенов\n', '        emit Burn(burner, _value);\n', '        emit Transfer(burner, address(0x0), _value);\n', '        return true;\n', '    }\n', '\n', '    function addSaleAgent (address _saleAgent) public onlyOwner {\n', '        saleAgents[_saleAgent] = true;\n', '    }\n', '\n', '    function disable () public onlyOwner {\n', '        require(isEnabled);\n', '        isEnabled = false;\n', '    }\n', '    function enable () public onlyOwner {\n', '        require(!isEnabled);\n', '        isEnabled = true;\n', '    }\n', '}\n', '\n', 'contract Token is TokenERC20 {\n', '    function Token() public TokenERC20("Ideal Digital Memory", "IDM") {}\n', '\n', '}']
