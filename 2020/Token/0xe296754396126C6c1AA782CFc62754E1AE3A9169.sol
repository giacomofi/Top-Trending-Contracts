['pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract AOENetwork is IERC20 {\n', '    uint256 private constant FLOAT_SCALAR = 2**64;\n', '    uint256 private constant INITIAL_SUPPLY = 1e27; // 1B\n', '    uint256 private constant BURN_RATE = 5; // 5% per tx\n', '    uint256 private constant SUPPLY_FLOOR = 10; // 10% of 1B = 100M\n', '    uint256 private constant MIN_FREEZE_AMOUNT = 1e20; // 100\n', '\n', '    string public constant name = "AOE Network";\n', '    string public constant symbol = "AOE";\n', '    uint8 public constant decimals = 18;\n', '\n', '    struct User {\n', '        bool whitelisted;\n', '        uint256 balance;\n', '        uint256 frozen;\n', '        mapping(address => uint256) allowance;\n', '        int256 scaledPayout;\n', '    }\n', '\n', '    struct Info {\n', '        uint256 totalSupply;\n', '        uint256 totalFrozen;\n', '        mapping(address => User) users;\n', '        uint256 scaledPayoutPerToken;\n', '        address admin;\n', '    }\n', '    Info private info;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 tokens\n', '    );\n', '    event Whitelist(address indexed user, bool status);\n', '    event Freeze(address indexed owner, uint256 tokens);\n', '    event Unfreeze(address indexed owner, uint256 tokens);\n', '    event Collect(address indexed owner, uint256 tokens);\n', '    event Burn(uint256 tokens);\n', '\n', '    constructor() public {\n', '        info.admin = msg.sender;\n', '        info.totalSupply = INITIAL_SUPPLY;\n', '        info.users[msg.sender].balance = INITIAL_SUPPLY;\n', '        emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);\n', '        whitelist(msg.sender, true);\n', '    }\n', '\n', '    function freeze(uint256 _tokens) external {\n', '        _freeze(_tokens);\n', '    }\n', '\n', '    function unfreeze(uint256 _tokens) external {\n', '        _unfreeze(_tokens);\n', '    }\n', '\n', '    function collect() external returns (uint256) {\n', '        uint256 _dividends = dividendsOf(msg.sender);\n', '        require(_dividends >= 0);\n', '        info.users[msg.sender].scaledPayout += int256(\n', '            _dividends * FLOAT_SCALAR\n', '        );\n', '        info.users[msg.sender].balance += _dividends;\n', '        emit Transfer(address(this), msg.sender, _dividends);\n', '        emit Collect(msg.sender, _dividends);\n', '        return _dividends;\n', '    }\n', '\n', '    function burn(uint256 _tokens) external {\n', '        require(balanceOf(msg.sender) >= _tokens);\n', '        info.users[msg.sender].balance -= _tokens;\n', '        uint256 _burnedAmount = _tokens;\n', '        if (info.totalFrozen > 0) {\n', '            _burnedAmount /= 2;\n', '            info.scaledPayoutPerToken +=\n', '                (_burnedAmount * FLOAT_SCALAR) /\n', '                info.totalFrozen;\n', '            emit Transfer(msg.sender, address(this), _burnedAmount);\n', '        }\n', '        info.totalSupply -= _burnedAmount;\n', '        emit Transfer(msg.sender, address(0x0), _burnedAmount);\n', '        emit Burn(_burnedAmount);\n', '    }\n', '\n', '    function distribute(uint256 _tokens) external {\n', '        require(info.totalFrozen > 0);\n', '        require(balanceOf(msg.sender) >= _tokens);\n', '        info.users[msg.sender].balance -= _tokens;\n', '        info.scaledPayoutPerToken +=\n', '            (_tokens * FLOAT_SCALAR) /\n', '            info.totalFrozen;\n', '        emit Transfer(msg.sender, address(this), _tokens);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _tokens) external returns (bool) {\n', '        _transfer(msg.sender, _to, _tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _tokens)\n', '        external\n', '        returns (bool)\n', '    {\n', '        info.users[msg.sender].allowance[_spender] = _tokens;\n', '        emit Approval(msg.sender, _spender, _tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _tokens\n', '    ) external returns (bool) {\n', '        require(info.users[_from].allowance[msg.sender] >= _tokens);\n', '        info.users[_from].allowance[msg.sender] -= _tokens;\n', '        _transfer(_from, _to, _tokens);\n', '        return true;\n', '    }\n', '\n', '    function whitelist(address _user, bool _status) public {\n', '        require(msg.sender == info.admin);\n', '        info.users[_user].whitelisted = _status;\n', '        emit Whitelist(_user, _status);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return info.totalSupply;\n', '    }\n', '\n', '    function totalFrozen() public view returns (uint256) {\n', '        return info.totalFrozen;\n', '    }\n', '\n', '    function balanceOf(address _user) public view returns (uint256) {\n', '        return info.users[_user].balance - frozenOf(_user);\n', '    }\n', '\n', '    function frozenOf(address _user) public view returns (uint256) {\n', '        return info.users[_user].frozen;\n', '    }\n', '\n', '    function dividendsOf(address _user) public view returns (uint256) {\n', '        return\n', '            uint256(\n', '                int256(info.scaledPayoutPerToken * info.users[_user].frozen) -\n', '                    info.users[_user].scaledPayout\n', '            ) / FLOAT_SCALAR;\n', '    }\n', '\n', '    function allowance(address _user, address _spender)\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return info.users[_user].allowance[_spender];\n', '    }\n', '\n', '    function isWhitelisted(address _user) public view returns (bool) {\n', '        return info.users[_user].whitelisted;\n', '    }\n', '\n', '    function allInfoFor(address _user)\n', '        public\n', '        view\n', '        returns (\n', '            uint256 totalTokenSupply,\n', '            uint256 totalTokensFrozen,\n', '            uint256 userBalance,\n', '            uint256 userFrozen,\n', '            uint256 userDividends\n', '        )\n', '    {\n', '        return (\n', '            totalSupply(),\n', '            totalFrozen(),\n', '            balanceOf(_user),\n', '            frozenOf(_user),\n', '            dividendsOf(_user)\n', '        );\n', '    }\n', '\n', '    function _transfer(\n', '        address _from,\n', '        address _to,\n', '        uint256 _tokens\n', '    ) internal returns (uint256) {\n', '        require(balanceOf(_from) >= _tokens);\n', '        info.users[_from].balance -= _tokens;\n', '        uint256 _burnedAmount = (_tokens * BURN_RATE) / 100;\n', '        if (\n', '            totalSupply() - _burnedAmount <\n', '            (INITIAL_SUPPLY * SUPPLY_FLOOR) / 100 ||\n', '            isWhitelisted(_from)\n', '        ) {\n', '            _burnedAmount = 0;\n', '        }\n', '        uint256 _transferred = _tokens - _burnedAmount;\n', '        info.users[_to].balance += _transferred;\n', '        emit Transfer(_from, _to, _transferred);\n', '        if (_burnedAmount > 0) {\n', '            if (info.totalFrozen > 0) {\n', '                _burnedAmount /= 2;\n', '                info.scaledPayoutPerToken +=\n', '                    (_burnedAmount * FLOAT_SCALAR) /\n', '                    info.totalFrozen;\n', '                emit Transfer(_from, address(this), _burnedAmount);\n', '            }\n', '            info.totalSupply -= _burnedAmount;\n', '            emit Transfer(_from, address(0x0), _burnedAmount);\n', '            emit Burn(_burnedAmount);\n', '        }\n', '        return _transferred;\n', '    }\n', '\n', '    function _freeze(uint256 _amount) internal {\n', '        require(balanceOf(msg.sender) >= _amount);\n', '        require(frozenOf(msg.sender) + _amount >= MIN_FREEZE_AMOUNT);\n', '        info.totalFrozen += _amount;\n', '        info.users[msg.sender].frozen += _amount;\n', '        info.users[msg.sender].scaledPayout += int256(\n', '            _amount * info.scaledPayoutPerToken\n', '        );\n', '        emit Transfer(msg.sender, address(this), _amount);\n', '        emit Freeze(msg.sender, _amount);\n', '    }\n', '\n', '    function _unfreeze(uint256 _amount) internal {\n', '        require(frozenOf(msg.sender) >= _amount);\n', '        uint256 _burnedAmount = (_amount * BURN_RATE) / 100;\n', '        info.scaledPayoutPerToken +=\n', '            (_burnedAmount * FLOAT_SCALAR) /\n', '            info.totalFrozen;\n', '        info.totalFrozen -= _amount;\n', '        info.users[msg.sender].balance -= _burnedAmount;\n', '        info.users[msg.sender].frozen -= _amount;\n', '        info.users[msg.sender].scaledPayout -= int256(\n', '            _amount * info.scaledPayoutPerToken\n', '        );\n', '        emit Transfer(address(this), msg.sender, _amount - _burnedAmount);\n', '        emit Unfreeze(msg.sender, _amount);\n', '    }\n', '}']