['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-09\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library SafeMath {\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract TokenERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '    \n', '    address public _owner;\n', '    string private _name = "Bensonas";\n', '    string private _symbol = "BNS";\n', '    uint8 private _decimals = 8;\n', '    uint256 private _totalSupply = 558000000000000;\n', '\tuint256 private _blockNumberStart = 0;\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    constructor () public {\n', '\t\t_owner = msg.sender;\n', '        _balances[msg.sender] = _totalSupply;\n', '        _blockNumberStart = block.number;\n', '        emit Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    function blockNumberStart() public view returns (uint256) {\n', '        return _blockNumberStart;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        return _balances[owner];\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        _transfer(msg.sender, to, value);\n', '        _unlockTokens();\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        _approve(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        _transfer(from, to, value);\n', '        _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        require(from != address(0), "ERC20: transfer from the zero address");\n', '        require(to != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _balances[from] = _balances[from].sub(value);\n', '        _balances[to] = _balances[to].add(value);\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 value) internal {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = value;\n', '        emit Approval(owner, spender, value);\n', '    }\n', '\n', '\tfunction burn(uint256 value) public {\n', '        require(msg.sender != address(0), "ERC20: burn from the zero address");\n', '        require(_owner == msg.sender, "ERC20: burn only owner address");\n', '\n', '        _totalSupply = _totalSupply.sub(value);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '        emit Transfer(msg.sender, address(0), value);\n', '    }\n', '    \n', '    function _mint(uint256 value) internal {\n', '        _totalSupply = _totalSupply.add(value);\n', '        _balances[_owner] = _balances[_owner].add(value);\n', '        emit Transfer(address(0), _owner, value);\n', '    }\n', '    \n', '    bool private _unlockTeam = true;\n', '    bool private _unlockDao = true;\n', '    uint256 private _daoTotal = 900000000000000;\n', '    uint256 private _daoTotalUnloked = 0;\n', '\n', '    function _unlockTokens() internal {\n', '      // Unlocking team tokens after year (2425846 blocks after start, 1 block = 13 sec)\n', '      if(_unlockTeam && block.number >= _blockNumberStart + 2425846){\n', '        _unlockTeam = false;\n', '        _mint(342000000000000);\n', '      }\n', '\n', '      // Unlock DAO, 5% per 6 month (1212923 blocks = 6 month, 1 block = 13 sec)\n', '      if(_unlockDao){\n', '        uint256 _amountToUnlock = 45000000000000;\n', '        uint256 _amountTotalUnlocked = 0;\n', '\n', '        for (uint i=1; i<=20; i++) {\n', '          uint256 _blockNumberToUnlock = _blockNumberStart + (1212923 * i);\n', '          if(block.number >= _blockNumberToUnlock){\n', '            _amountTotalUnlocked = _amountTotalUnlocked.add(_amountToUnlock);\n', '            if(_daoTotalUnloked < _amountTotalUnlocked){\n', '              _daoTotalUnloked = _daoTotalUnloked.add(_amountToUnlock);\n', '              _mint(_amountToUnlock);\n', '            }\n', '          }\n', '        }\n', '\n', '        if(_daoTotal == _daoTotalUnloked){\n', '          _unlockDao = false;\n', '        }\n', '      }\n', '    }\n', '}']