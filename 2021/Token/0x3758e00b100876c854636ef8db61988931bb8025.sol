['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-12\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.8.2;\n', '\n', '// Contracts interaction interface\n', 'abstract contract IContract {\n', '    function balanceOf(address owner) external virtual returns (uint256);\n', '\n', '    function transfer(address to, uint256 value) external virtual;\n', '}\n', '\n', '// https://eips.ethereum.org/EIPS/eip-20\n', 'contract UniqToken {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '\n', '    mapping(address => uint256) private balances;\n', '    mapping(address => mapping(address => uint256)) private allowed;\n', '    uint256 public totalSupply;\n', '    address public owner;\n', '    address constant ZERO = address(0);\n', '\n', '    modifier notZeroAddress(address a) {\n', '        require(a != ZERO, "Address 0x0 not allowed");\n', '        _;\n', '    }\n', '\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customize the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public constant name = "Uniqly"; // Token name\n', '    string public constant symbol = "UNIQ"; // Token symbol\n', '    uint8 public constant decimals = 18; // Token decimals\n', '\n', '    constructor(uint256 _initialAmount) {\n', '        balances[msg.sender] = _initialAmount; // Give the creator all initial tokens\n', '        totalSupply = _initialAmount; // Update total supply\n', '        owner = msg.sender; // Set owner\n', '        emit Transfer(ZERO, msg.sender, _initialAmount); // Emit event\n', '    }\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return success Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value)\n', '        external\n', '        notZeroAddress(_to)\n', '        returns (bool)\n', '    {\n', '        require(\n', '            balances[msg.sender] >= _value,\n', '            "ERC20 transfer: token balance too low"\n', '        );\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return success Whether the transfer was successful or not\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    ) external notZeroAddress(_to) returns (bool) {\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '        require(\n', '            balances[_from] >= _value && _allowance >= _value,\n', '            "ERC20 transferFrom: token balance or allowance too low"\n', '        );\n', '        balances[_from] -= _value;\n', '        if (_allowance < (2**256 - 1)) {\n', '            _approve(_from, msg.sender, _allowance - _value);\n', '        }\n', '        balances[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return balance the balance\n', '    function balanceOf(address _owner) external view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return success Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value)\n', '        external\n', '        notZeroAddress(_spender)\n', '        returns (bool)\n', '    {\n', '        _approve(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function _approve(\n', '        address _owner,\n', '        address _spender,\n', '        uint256 _amount\n', '    ) internal {\n', '        allowed[_owner][_spender] = _amount;\n', '        emit Approval(_owner, _spender, _amount);\n', '    }\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return remaining Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from the caller.\n', '     *\n', '     * See {_burn}.\n', '     */\n', '    function burn(uint256 amount) external {\n', '        _burn(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', "     * @dev Destroys `amount` tokens from `account`, deducting from the caller's\n", '     * allowance.\n', '     *\n', '     * See {_burn} and {allowance}.\n', '     *\n', '     * Requirements:\n', '     *\n', "     * - the caller must have allowance for ``accounts``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function burnFrom(address account, uint256 amount) external {\n', '        uint256 currentAllowance = allowed[account][msg.sender];\n', '        require(\n', '            currentAllowance >= amount,\n', '            "ERC20: burn amount exceeds allowance"\n', '        );\n', '        _approve(account, msg.sender, currentAllowance - amount);\n', '        _burn(account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(address account, uint256 amount)\n', '        internal\n', '        notZeroAddress(account)\n', '    {\n', '        require(\n', '            balances[account] >= amount,\n', '            "ERC20: burn amount exceeds balance"\n', '        );\n', '        balances[account] -= amount;\n', '        totalSupply -= amount;\n', '\n', '        emit Transfer(account, ZERO, amount);\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Only for Owner");\n', '        _;\n', '    }\n', '\n', '    // change ownership in two steps to be sure about owner address\n', '    address public newOwner;\n', '\n', '    // only current owner can delegate new one\n', '    function giveOwnership(address _newOwner) external onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    // new owner need to accept ownership\n', '    function acceptOwnership() external {\n', '        require(msg.sender == newOwner, "You are not New Owner");\n', '        newOwner = address(0);\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    @dev Function to recover accidentally send ERC20 tokens\n', '    @param _token ERC20 token address\n', '    */\n', '    function rescueERC20(address _token) external onlyOwner {\n', '        uint256 amt = IContract(_token).balanceOf(address(this));\n', '        require(amt > 0, "Nothing to rescue");\n', '        IContract(_token).transfer(owner, amt);\n', '    }\n', '\n', '    /**\n', '    @dev Function to recover any ETH send to contract\n', '    */\n', '    function rescueETH() external onlyOwner {\n', '        payable(owner).transfer(address(this).balance);\n', '    }\n', '}']