['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-08\n', '*/\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'interface IERC20 {\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(isOwner(), "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function owner(\n', '  ) public view returns (address) {\n', '    return _owner;\n', '  }\n', '\n', '  function isOwner(\n', '  ) public view returns (bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '}\n', 'pragma solidity ^0.6.2;\n', '\n', 'contract Pausable is Ownable {\n', '\n', '    event Paused(address account);\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    modifier whenNotPaused() \n', '    {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    constructor() internal {}\n', '\n', '    function paused(\n', '    ) public view returns (bool) \n', '    {\n', '        return _paused;\n', '    }\n', '\n', '    function pause(\n', '    ) public \n', '        onlyOwner \n', '        whenNotPaused \n', '    {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    function unpause(\n', '    ) public \n', '        onlyOwner \n', '        whenPaused \n', '    {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', 'contract ERC20 is IERC20, Ownable, Pausable {\n', '\n', '    using SafeMath for uint;\n', '\n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _totalSupply;\n', '\n', '    mapping (address => uint256) internal _balances;\n', '    mapping (address => mapping (address => uint256)) internal _allowed;\n', '\n', '    event Mint(address indexed minter, address indexed account, uint256 amount);\n', '    event Burn(address indexed burner, address indexed account, uint256 amount);\n', '\n', '    constructor (\n', '        string memory name, \n', '        string memory symbol, \n', '        uint8 decimals, \n', '        uint256 totalSupply\n', '    ) public\n', '    {\n', '        _symbol = symbol;\n', '        _name = name;\n', '        _decimals = decimals;\n', '        _totalSupply = totalSupply;\n', '        _balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function name(\n', '    ) public view returns (string memory)\n', '    {\n', '        return _name;\n', '    }\n', '\n', '    function symbol(\n', '    ) public view returns (string memory)\n', '    {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals(\n', '    ) public view returns (uint8)\n', '    {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply(\n', '    ) public view returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function transfer(\n', '        address _to, \n', '        uint256 _value\n', '    ) public override\n', '        whenNotPaused \n', '      returns (bool)\n', '    {\n', "        require(_to != address(0), 'ERC20: to address is not valid');\n", "        require(_value <= _balances[msg.sender], 'ERC20: insufficient balance');\n", '        \n', '        _balances[msg.sender] = SafeMath.sub(_balances[msg.sender], _value);\n', '        _balances[_to] = SafeMath.add(_balances[_to], _value);\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '   function balanceOf(\n', '       address _owner\n', '    ) public override view returns (uint256 balance) \n', '    {\n', '        return _balances[_owner];\n', '    }\n', '\n', '    function approve(\n', '       address _spender, \n', '       uint256 _value\n', '    ) public override\n', '        whenNotPaused\n', '      returns (bool) \n', '    {\n', '        _allowed[msg.sender][_spender] = _value;\n', '        \n', '        emit Approval(msg.sender, _spender, _value);\n', '        \n', '        return true;\n', '   }\n', '\n', '   function transferFrom(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) public override\n', '        whenNotPaused\n', '      returns (bool) \n', '    {\n', "        require(_from != address(0), 'ERC20: from address is not valid');\n", "        require(_to != address(0), 'ERC20: to address is not valid');\n", "        require(_value <= _balances[_from], 'ERC20: insufficient balance');\n", "        require(_value <= _allowed[_from][msg.sender], 'ERC20: from not allowed');\n", '\n', '        _balances[_from] = SafeMath.sub(_balances[_from], _value);\n', '        _balances[_to] = SafeMath.add(_balances[_to], _value);\n', '        _allowed[_from][msg.sender] = SafeMath.sub(_allowed[_from][msg.sender], _value);\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '   }\n', '\n', '    function allowance(\n', '        address _owner, \n', '        address _spender\n', '    ) public override view \n', '        whenNotPaused\n', '      returns (uint256) \n', '    {\n', '        return _allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(\n', '        address _spender, \n', '        uint _addedValue\n', '    ) public\n', '        whenNotPaused\n', '      returns (bool)\n', '    {\n', '        _allowed[msg.sender][_spender] = SafeMath.add(_allowed[msg.sender][_spender], _addedValue);\n', '        \n', '        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(\n', '        address _spender, \n', '        uint _subtractedValue\n', '    ) public\n', '        whenNotPaused\n', '      returns (bool) \n', '    {\n', '        uint oldValue = _allowed[msg.sender][_spender];\n', '        \n', '        if (_subtractedValue > oldValue) {\n', '            _allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            _allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);\n', '        }\n', '        \n', '        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);\n', '        \n', '        return true;\n', '   }\n', '\n', '    function mintTo(\n', '        address _to,\n', '        uint _amount\n', '    ) public\n', '        whenNotPaused\n', '        onlyOwner\n', '    {\n', "        require(_to != address(0), 'ERC20: to address is not valid');\n", "        require(_amount > 0, 'ERC20: amount is not valid');\n", '\n', '        _totalSupply = _totalSupply.add(_amount);\n', '        _balances[_to] = _balances[_to].add(_amount);\n', '\n', '        emit Mint(msg.sender, _to, _amount);\n', '    }\n', '\n', '    function burnFrom(\n', '        address _from,\n', '        uint _amount\n', '    ) public\n', '        whenNotPaused\n', '        onlyOwner\n', '    {\n', "        require(_from != address(0), 'ERC20: from address is not valid');\n", "        require(_balances[_from] >= _amount, 'ERC20: insufficient balance');\n", '        \n', '        _balances[_from] = _balances[_from].sub(_amount);\n', '        _totalSupply = _totalSupply.sub(_amount);\n', '\n', '        emit Burn(msg.sender, _from, _amount);\n', '    }\n', '\n', '}']