['pragma solidity ^0.4.24;\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md \n', ' * @author https://snowfox.tech/\n', ' */\n', ' \n', ' /**\n', '  * @title Base contract\n', '  * @dev Implements all the necessary logic for the token distribution (methods are closed. Inherited)\n', '  */\n', '\n', 'contract ERC20CoreBase {\n', '\n', '    // string public name;\n', '    // string public symbol;\n', '    // uint8 public decimals;\n', '\n', '\n', '    mapping (address => uint) internal _balanceOf;\n', '    uint internal _totalSupply; \n', '\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '\n', '    function totalSupply() public view returns(uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '\n', '    function balanceOf(address owner) public view returns(uint) {\n', '        return _balanceOf[owner];\n', '    }\n', '\n', '\n', '\n', '    /**\n', '    * @dev Transfer token for a specified addresses\n', '    * @param from The address to transfer from.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '\n', '    function _transfer(address from, address to, uint256 value) internal {\n', '        _checkRequireERC20(to, value, true, _balanceOf[from]);\n', '\n', '        _balanceOf[from] -= value;\n', '        _balanceOf[to] += value;\n', '        emit Transfer(from, to, value);\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Internal function that mints an amount of the token and assigns it to\n', '    * an account. This encapsulates the modification of balances such that the\n', '    * proper events are emitted.\n', '    * @param account The account that will receive the created tokens.\n', '    * @param value The amount that will be created.\n', '    */\n', '\n', '    function _mint(address account, uint256 value) internal {\n', '        _checkRequireERC20(account, value, false, 0);\n', '        _totalSupply += value;\n', '        _balanceOf[account] += value;\n', '        emit Transfer(address(0), account, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Internal function that burns an amount of the token of a given\n', '    * account.\n', '    * @param account The account whose tokens will be burnt.\n', '    * @param value The amount that will be burnt.\n', '    */\n', '\n', '    function _burn(address account, uint256 value) internal {\n', '        _checkRequireERC20(account, value, true, _balanceOf[account]);\n', '\n', '        _totalSupply -= value;\n', '        _balanceOf[account] -= value;\n', '        emit Transfer(account, address(0), value);\n', '    }\n', '\n', '\n', '    function _checkRequireERC20(address addr, uint value, bool checkMax, uint max) internal pure {\n', '        require(addr != address(0), "Empty address");\n', '        require(value > 0, "Empty value");\n', '        if (checkMax) {\n', '            require(value <= max, "Out of value");\n', '        }\n', '    }\n', '\n', '} \n', '\n', '\n', '\n', '/**\n', ' * @title The logic of trust management (methods closed. Inherited).\n', ' */\n', 'contract ERC20WithApproveBase is ERC20CoreBase {\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    ); \n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param owner address The address which owns the funds.\n', '    * @param spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    \n', '    function allowance(address owner, address spender) public view returns(uint) {\n', '        return _allowed[owner][spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to be spent.\n', '    */\n', '\n', '    function _approve(address spender, uint256 value) internal {\n', '        _checkRequireERC20(spender, value, true, _balanceOf[msg.sender]);\n', '\n', '        _allowed[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param from address The address which you want to send tokens from\n', '    * @param to address The address which you want to transfer to\n', '    * @param value uint256 the amount of tokens to be transferred\n', '    */\n', '\n', '    function _transferFrom(address from, address to, uint256 value) internal {\n', '        _checkRequireERC20(to, value, true, _allowed[from][msg.sender]);\n', '\n', '        _allowed[from][msg.sender] -= value;\n', '        _transfer(from, to, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed_[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to increase the allowance by.\n', '    */\n', '\n', '    function _increaseAllowance(address spender, uint256 value)  internal {\n', '        _checkRequireERC20(spender, value, false, 0);\n', '        require(_balanceOf[msg.sender] >= (_allowed[msg.sender][spender] + value), "Out of value");\n', '\n', '        _allowed[msg.sender][spender] += value;\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed_[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to decrease the allowance by.\n', '    */\n', '\n', '    function _decreaseAllowance(address spender, uint256 value) internal {\n', '        _checkRequireERC20(spender, value, true, _allowed[msg.sender][spender]);\n', '\n', '        _allowed[msg.sender][spender] -= value;\n', '        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title The logic of trust management (public methods).\n', ' */\n', 'contract ERC20WithApprove is ERC20WithApproveBase {\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to be spent.\n', '    */\n', '\n', '    function approve(address spender, uint256 value) public {\n', '        _approve(spender, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param from address The address which you want to send tokens from\n', '    * @param to address The address which you want to transfer to\n', '    * @param value uint256 the amount of tokens to be transferred\n', '    */\n', '\n', '    function transferFrom(address from, address to, uint256 value) public {\n', '        _transferFrom(from, to, value);\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed_[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to increase the allowance by.\n', '    */\n', '\n', '    function increaseAllowance(address spender, uint256 value)  public {\n', '        _increaseAllowance(spender, value);\n', '    }\n', '\n', '\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed_[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to decrease the allowance by.\n', '    */\n', '\n', '    function decreaseAllowance(address spender, uint256 value) public {\n', '        _decreaseAllowance(spender, value);\n', '    }\n', '} \n', '\n', '\n', '/**\n', ' * @title Main contract\n', ' * @dev Start data and access to transfer method\n', ' * \n', ' */\n', '\n', 'contract ERC20 is ERC20WithApprove {\n', '\tstring public name;\n', '\tstring public symbol;\n', '\tuint public decimals;\n', '\n', '\tconstructor(string _name, string _symbol, uint _decimals, uint total, address target) public {\n', '\t\tname = _name;\n', '\t\tsymbol = _symbol;\n', '\t\tdecimals = _decimals;\n', '\n', '\t\t_mint(target, total);\n', '\t}\n', '\n', '\tfunction transfer(address to, uint value) public {\n', '\t\t_transfer(msg.sender, to, value);\n', '\t}\n', '}']