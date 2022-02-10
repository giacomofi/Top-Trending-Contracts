['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    emit Transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param amount The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(amount);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param amount The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(account != 0);\n', '    require(amount <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account, deducting from the sender&#39;s allowance for said account. Uses the\n', '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param amount The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 amount) internal {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      amount);\n', '    _burn(account, amount);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract ERC20Burnable is ERC20 {\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens.\n', '   * @param value The amount of token to be burned.\n', '   */\n', '  function burn(uint256 value) public {\n', '    _burn(msg.sender, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '   * @param from address The address which you want to send tokens from\n', '   * @param value uint256 The amount of token to be burned\n', '   */\n', '  function burnFrom(address from, uint256 value) public {\n', '    _burnFrom(from, value);\n', '  }\n', '\n', '  /**\n', '   * @dev Overrides ERC20._burn in order for burn and burnFrom to emit\n', '   * an additional Burn event.\n', '   */\n', '  function _burn(address who, uint256 value) internal {\n', '    super._burn(who, value);\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    IERC20 token,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    IERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(\n', '    IERC20 token,\n', '    address spender,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    _owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(_owner);\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/robonomics/Ambix.sol\n', '\n', '/**\n', '  @dev Ambix contract is used for morph Token set to another\n', '  Token&#39;s by rule (recipe). In distillation process given\n', '  Token&#39;s are burned and result generated by emission.\n', '  \n', '  The recipe presented as equation in form:\n', '  (N1 * A1 & N&#39;1 * A&#39;1 & N&#39;&#39;1 * A&#39;&#39;1 ...)\n', '  | (N2 * A2 & N&#39;2 * A&#39;2 & N&#39;&#39;2 * A&#39;&#39;2 ...) ...\n', '  | (Nn * An & N&#39;n * A&#39;n & N&#39;&#39;n * A&#39;&#39;n ...)\n', '  = M1 * B1 & M2 * B2 ... & Mm * Bm \n', '    where A, B - input and output tokens\n', '          N, M - token value coeficients\n', '          n, m - input / output dimetion size \n', '          | - is alternative operator (logical OR)\n', '          & - is associative operator (logical AND)\n', '  This says that `Ambix` should receive (approve) left\n', '  part of equation and send (transfer) right part.\n', '*/\n', 'contract Ambix is Ownable {\n', '    using SafeERC20 for ERC20Burnable;\n', '    using SafeERC20 for ERC20;\n', '\n', '    address[][] public A;\n', '    uint256[][] public N;\n', '    address[] public B;\n', '    uint256[] public M;\n', '\n', '    /**\n', '     * @dev Append token recipe source alternative\n', '     * @param _a Token recipe source token addresses\n', '     * @param _n Token recipe source token counts\n', '     **/\n', '    function appendSource(\n', '        address[] _a,\n', '        uint256[] _n\n', '    ) external onlyOwner {\n', '        uint256 i;\n', '\n', '        require(_a.length == _n.length && _a.length > 0);\n', '\n', '        for (i = 0; i < _a.length; ++i)\n', '            require(_a[i] != 0);\n', '\n', '        if (_n.length == 1 && _n[0] == 0) {\n', '            require(B.length == 1);\n', '        } else {\n', '            for (i = 0; i < _n.length; ++i)\n', '                require(_n[i] > 0);\n', '        }\n', '\n', '        A.push(_a);\n', '        N.push(_n);\n', '    }\n', '\n', '    /**\n', '     * @dev Set sink of token recipe\n', '     * @param _b Token recipe sink token list\n', '     * @param _m Token recipe sink token counts\n', '     */\n', '    function setSink(\n', '        address[] _b,\n', '        uint256[] _m\n', '    ) external onlyOwner{\n', '        require(_b.length == _m.length);\n', '\n', '        for (uint256 i = 0; i < _b.length; ++i)\n', '            require(_b[i] != 0);\n', '\n', '        B = _b;\n', '        M = _m;\n', '    }\n', '\n', '    /**\n', '     * @dev Run distillation process\n', '     * @param _ix Source alternative index\n', '     */\n', '    function run(uint256 _ix) public {\n', '        require(_ix < A.length);\n', '        uint256 i;\n', '\n', '        if (N[_ix][0] > 0) {\n', '            // Static conversion\n', '\n', '            // Token count multiplier\n', '            uint256 mux = ERC20(A[_ix][0]).allowance(msg.sender, this) / N[_ix][0];\n', '            require(mux > 0);\n', '\n', '            // Burning run\n', '            for (i = 0; i < A[_ix].length; ++i)\n', '                ERC20Burnable(A[_ix][i]).burnFrom(msg.sender, mux * N[_ix][i]);\n', '\n', '            // Transfer up\n', '            for (i = 0; i < B.length; ++i)\n', '                ERC20(B[i]).safeTransfer(msg.sender, M[i] * mux);\n', '\n', '        } else {\n', '            // Dynamic conversion\n', '            //   Let source token total supply is finite and decrease on each conversion,\n', '            //   just convert finite supply of source to tokens on balance of ambix.\n', '            //         dynamicRate = balance(sink) / total(source)\n', '\n', '            // Is available for single source and single sink only\n', '            require(A[_ix].length == 1 && B.length == 1);\n', '\n', '            ERC20Burnable source = ERC20Burnable(A[_ix][0]);\n', '            ERC20 sink = ERC20(B[0]);\n', '\n', '            uint256 scale = 10 ** 18 * sink.balanceOf(this) / source.totalSupply();\n', '\n', '            uint256 allowance = source.allowance(msg.sender, this);\n', '            require(allowance > 0);\n', '            source.burnFrom(msg.sender, allowance);\n', '\n', '            uint256 reward = scale * allowance / 10 ** 18;\n', '            require(reward > 0);\n', '            sink.safeTransfer(msg.sender, reward);\n', '        }\n', '    }\n', '}']