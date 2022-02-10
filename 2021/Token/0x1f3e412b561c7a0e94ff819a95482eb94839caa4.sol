['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-10\n', '*/\n', '\n', '// SPDX-License-Identifier: ISC\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', '\n', '/* ----------------------------------------------------------------------------\n', ' \n', " 'GToken' contract \n", '\n', ' * Symbol      : GTO\n', ' * Name        : GToken\n', ' * Total supply: 1 trillion\n', ' * Decimals    : 18\n', '\n', '---------------------------------------------------------------------------- */ \n', ' \n', '\n', 'interface IGtoken {\n', '    /**\n', '     * @dev returns the name of the token\n', '     */\n', '    function name() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev returns the symbol of the token\n', '     */\n', '    function symbol() external view returns (string memory);\n', '\n', '    /**\n', '     * @dev returns the decimal places of a token\n', '     */\n', '    function decimals() external view returns (uint8);\n', '\n', '    /**\n', '     * @dev returns the total tokens in existence\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev returns the tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev transfers the `amount` of tokens from caller's account\n", '     * to the `recipient` account.\n', '     *\n', '     * returns boolean value indicating the operation status.\n', '     *\n', '     * Emits a {Transfer} event\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', "     * @dev returns the remaining number of tokens the `spender' can spend\n", '     * on behalf of the owner.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} is executed.\n', '     */\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    /**\n', '     * @dev sets `amount` as the `allowance` of the `spender`.\n', '     *\n', '     * returns a boolean value indicating the operation status.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev transfers the `amount` on behalf of `spender` to the `recipient` account.\n', '     *\n', '     * returns a boolean indicating the operation status.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address spender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    /**\n', "     * @dev Emitted from tokens are moved from one account('from') to another account ('to)\n", '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when allowance of a `spender` is set by the `owner`\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '\n', 'abstract contract Context {\n', '\n', '    function msgSender() internal view virtual returns(address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function msgData() internal view virtual returns(bytes calldata) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '\n', '    function msgValue() internal view virtual returns(uint256) {\n', '        return msg.value;\n', '    }\n', '\n', '}\n', '\n', 'contract GToken is IGtoken, Context {\n', '    \n', '    mapping(address => uint256) private balances;\n', '\n', '    mapping(address => mapping(address => uint256)) private allowances;\n', '\n', '    address private _governor;\n', '\n', '    uint256 private _totalSupply;\n', '\n', '    uint256 public feeFraction = 10;\n', '\n', '    string private _name;\n', '\n', '    string private _symbol;\n', '\n', '    // allowedAddresses will be able to transfer even when locked\n', '    mapping(address => bool) public allowedAddresses;\n', '\n', '    // lockedAddresses will *not* be able to transfer even when *not locked*\n', '    mapping(address => bool) public lockedAddresses;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    bool public freezed = false;\n', '\n', '    /**\n', '     * @dev checks whether `caller` is governor;\n', '    */\n', '    modifier onlyGovernor() {\n', '        require(msgSender() == _governor, "ERC20: caller not governor");\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev adds the address to the list of allowedAddresses\n', '    */\n', '    function allowAddress(address _addr, bool _allowed) public onlyGovernor {\n', '        require(_addr != _governor);\n', '        allowedAddresses[_addr] = _allowed;\n', '    }\n', '\n', '    /**\n', '     * @dev adds the address to the list of lockedAddresses\n', '    */\n', '    function lockAddress(address _addr, bool _locked) public onlyGovernor {\n', '        require(_addr != _governor);\n', '        lockedAddresses[_addr] = _locked;\n', '    }\n', '\n', '    /**\n', '     * @dev freezes the contract\n', '    */\n', '    function freeze() public onlyGovernor {\n', '        freezed = true;\n', '    }\n', '\n', '    /**\n', '     * @dev unfreezes the contract\n', '    */\n', '    function unfreeze() public onlyGovernor {\n', '        freezed = false;\n', '    }\n', '\n', '    /**\n', '     * @dev validates the transfer\n', '    */\n', '    function validateTransfer(address _addr) internal view returns (bool) {\n', '       \n', '        if(freezed){\n', '           \n', '            if(!allowedAddresses[_addr]&&_addr!=_governor) \n', '                return false;\n', '        }\n', '        \n', '        else if(lockedAddresses[_addr]) \n', '            return false;\n', '\n', '        return true;\n', '    }\n', '\n', ' \n', '\n', '    /**\n', '     * @dev sets the {name}, {symbol} and {governor wallet} of the token.\n', '     *\n', '     * All the two variables are immutable and cannot be changed\n', '     * and set only in the constructor.\n', '     */\n', '    constructor(string memory name_, string memory symbol_, address _governorAddress) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '        _governor = _governorAddress;\n', '     }\n', '\n', '    /**\n', '     * @dev returns the name of the token.\n', '     */\n', '    function name() public view virtual override returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev returns the symbol of the token.\n', '     */\n', '    function symbol() public view virtual override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev returns the decimals of the token\n', '     */\n', '    function decimals() public view virtual override returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    /**\n', '     * @dev returns the total supply of the token\n', '     */\n', '    function totalSupply() public view virtual override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev returns the number of tokens owned by `account`\n', '     */\n', '    function balanceOf(address account)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint256)\n', '    {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev returns the amount the `spender` can spend on behalf of the `owner`.\n', '     */\n', '    function allowance(address owner, address spender)\n', '        public\n', '        view\n', '        virtual\n', '        override\n', '        returns (uint256)\n', '    {\n', '        return allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Approve a `spender` to spend tokens on behalf of the `owner`.\n', '     */\n', '    function approve(address spender, uint256 value)\n', '        public\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        _approve(msgSender(), spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev to increase the allowance of `spender` over the `owner` account.\n', '     *\n', '     * Requirements\n', '     * `spender` cannot be zero address\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        _approve(\n', '            msgSender(),\n', '            spender,\n', '            allowances[msgSender()][spender] + addedValue\n', '        );\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev to decrease the allowance of `spender` over the `owner` account.\n', '     *\n', '     * Requirements\n', '     * `spender` allowance shoule be greater than the `reducedValue`\n', '     * `spender` cannot be a zero address\n', '     */\n', '    function decreaseAllowance(address spender, uint256 reducedValue)\n', '        public\n', '        virtual\n', '        returns (bool)\n', '    {\n', '        uint256 currentAllowance = allowances[msgSender()][spender];\n', '        require(\n', '            currentAllowance >= reducedValue,\n', '            "ERC20: ReducedValue greater than allowance"\n', '        );\n', '\n', '        _approve(msgSender(), spender, currentAllowance - reducedValue);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev sets the amount as the allowance of `spender` over the `owner` address\n', '     *\n', '     * Requirements:\n', '     * `owner` cannot be zero address\n', '     * `spender` cannot be zero address\n', '     */\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from zero address");\n', '        require(spender != address(0), "ERC20: approve to zero address");\n', '\n', '        allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev transfers the `amount` of tokens to `recipient`\n', '     */\n', '    function transfer(address recipient, uint256 amount)\n', '        public\n', '        virtual\n', '        override\n', '        returns (bool)\n', '    {\n', '        require(validateTransfer(msgSender()),"ERC20: Transfer reverted");\n', '\n', '        _transfer(msgSender(), recipient, amount);\n', '\n', '        emit Transfer(msgSender(), recipient, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', "     * @dev transfers the 'amount` from the `sender` to the `recipient`\n", '     * on behalf of the `sender`.\n', '     *\n', '     * Requirements\n', '     * `sender` and `recipient` should be non zero addresses\n', '     * `sender` should have balance of more than `amount`\n', '     * `caller` must have allowance greater than `amount`\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public virtual override returns (bool) {\n', '        require(validateTransfer(sender),"ERC20: Transfer reverted");\n', '        \n', '        _transfer(sender, recipient, amount);\n', '\n', '        uint256 currentAllowance = allowances[sender][msgSender()];\n', '        require(currentAllowance >= amount, "ERC20: amount exceeds allowance");\n', '        _approve(sender, msgSender(), currentAllowance - amount);\n', '      \n', '        emit Transfer(sender, recipient, amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev mints the amount of tokens to the `recipient` wallet.\n', '     *\n', '     * Requirements :\n', '     *\n', '     * The caller must be the `governor` of the contract.\n', '     * Governor can be an DAO smart contract.\n', '     */\n', '    function mint(address recipient, uint256 amount)\n', '        public\n', '        virtual\n', '        onlyGovernor\n', '        returns (bool)\n', '    {\n', '        require(recipient != address(0), "ERC20: mint to a zero address");\n', '\n', ' \n', '        _totalSupply += amount;\n', '        balances[recipient] += amount;\n', '\n', '        emit Transfer(address(0), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev burns the `amount` tokens from `supply`.\n', '     *\n', '     * Requirements\n', '     * `caller` address balance should be greater than `amount`\n', '     */\n', '    function burn(uint256 amount) public virtual onlyGovernor returns (bool) {\n', '        uint256 currentBalance = balances[msgSender()];\n', '        require(\n', '            currentBalance >= amount,\n', '            "ERC20: burning amount exceeds balance"\n', '        );\n', '\n', '        balances[msgSender()] = currentBalance - amount;\n', '        _totalSupply -= amount;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev transfers the `amount` of tokens from `sender` to `recipient`.\n', '     *\n', '     * Requirements:\n', '     * `sender` is not a zero address\n', '     * `recipient` is also not a zero address\n', '     * `amount` is less than or equal to balance of the sender.\n', '     */\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from zero address");\n', '        require(recipient != address(0), "ERC20: transfer to zero address");\n', '\n', '        uint256 senderBalance = balances[sender];\n', '        require(\n', '            senderBalance >= amount,\n', '            "ERC20: transfer amount exceeds balance"\n', '        );\n', '\n', '     \n', '        balances[sender] = senderBalance - amount;\n', '        \n', '        // Transfer the spread to the admin\n', '        uint256 fee = amount * feeFraction / 10**4;\n', '\n', '        uint256 receiverAmount = amount - fee;\n', '\n', '        balances[recipient] += receiverAmount;\n', '        balances[_governor] +=fee;\n', '\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev returns the current `governor` address.\n', '     *\n', '     * `governors` can mint / burn Gtokens\n', '     */\n', '    function governor() public view virtual returns (address) {\n', '        return _governor;\n', '    }\n', '\n', '    /**\n', '     * @dev transfers the governance of the contract.\n', '     *\n', '     * Requirements :\n', '     * `caller` should be the current governor.\n', '     * `newGovernor` cannot be a zero address.\n', '     */\n', '    function transferGovernance(address newGovernor)\n', '        public\n', '        virtual\n', '        onlyGovernor\n', '        returns (bool)\n', '    {\n', '        require(newGovernor != address(0), "ERC20: zero address cannot govern");\n', '        _governor = newGovernor;\n', '        return true;\n', '    }\n', ' \n', '    /**\n', '     * @dev changes the transaction fee.\n', '     *\n', '     * Requirements :\n', '     * `caller` should be the current governor.\n', '     * `transactionFee` cannot be less than zero.\n', '     */\n', '    function setTransactionFee(uint256 _newFeeFraction)\n', '        public\n', '        virtual\n', '        onlyGovernor\n', '        returns (bool)\n', '    {\n', '        require(_newFeeFraction >= 0, "ERC20: fee must not be negative");\n', '        feeFraction = _newFeeFraction;\n', '        return true;\n', '    }\n', '\n', '   \n', '}']