['pragma solidity ^0.5.0;\n', '\n', '//  /$$$$$$$$ /$$       /$$                 /$$                 /$$$$$$$$ /$$                    \n', '// |__  $$__/| $$      |__/                |__/                | $$_____/|__/                    \n', '//    | $$   | $$$$$$$  /$$  /$$$$$$$       /$$  /$$$$$$$      | $$       /$$ /$$$$$$$   /$$$$$$ \n', '//    | $$   | $$__  $$| $$ /$$_____/      | $$ /$$_____/      | $$$$$   | $$| $$__  $$ /$$__  $$\n', '//    | $$   | $$  \\ $$| $$|  $$$$$$       | $$|  $$$$$$       | $$__/   | $$| $$  \\ $$| $$$$$$$$\n', '//    | $$   | $$  | $$| $$ \\____  $$      | $$ \\____  $$      | $$      | $$| $$  | $$| $$_____/\n', '//    | $$   | $$  | $$| $$ /$$$$$$$/      | $$ /$$$$$$$/      | $$      | $$| $$  | $$|  $$$$$$$\n', '//    |__/   |__/  |__/|__/|_______/       |__/|_______/       |__/      |__/|__/  |__/ \\_______/\n', '//\n', '// \n', '//    Official Telegram: t.me/thisisfinetoken\n', '//    Only 100 TIF. 2% Burn. "THINGS ARE GOING TO BE OKAY"\n', '// \n', '// \n', '// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n', '// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n', '// @@@@@@@@@@@@@@@@@@#####@@@@@@@@@@@@@#@@@@@@@@@@@@@@@###@@@@@@@@@@@@@@@@@#######@\n', '// ###@@@@@@@@@@#############################@@@@@@###########@@@@@@@@@############\n', '// ###@#######@###############@@##########@################@@@@@@@###@####@#####@@@\n', '// ############@###@@@@@@@#####@..+@@@+`    @@########@@@#####@##@@###@@@##########\n', "// #######@#####@@@#######@@@;                      ;;;;;;';'';;;;@@@######@+  ;@@@\n", "// @####@:                                          '';#########+;;    ``          \n", "//                              `,:''               ;;;#########+;@                \n", "//             @@@@@@@@@@@@@@@@@@@@@@               ;;;##@######';#                \n", "//             @                  @@@               ';;####@####;;@                \n", "//       @`    @        `      `  @@@               ;;;######@##''@                \n", "//      @@@    @     #@@       @;::@@               ;;;#########;'@          @     \n", "//     @@@@@   @   #@@@.   @  @:::;+@@:'`           ;;;#####@##@;;@          @@:   \n", "//    @@@@@@   @  @@@@@    @@  ;@@@@;::;`           ;';''''''+#;;;.          .@@`  \n", '//   @@@@@@#   @ @@@@@@   @@@@::::::::#+;;;@        #;;;;;;;;;;;;@            @@@  \n', "//   @@@@@@@   @@@@,@@@  ;@@@@@:::;+@;;::::@'#.                              ,@@@  \n", "// @.@@@,@@@   @@@,,:@@@ @@:,@@ @;;:+#;;:+  @@@@                   '         @@@@`@\n", "// @@@@@,@@@ ' @@@,,,@@@@@@,,,@@@;+ .. @;@ @@@@+                 @@         @@@@@@@\n", "// @@@@@,@@  @+'@,,,,,@@@@,,@@@@@: '@@@ @+` @@@@#@@@@@@+       ;@@#        @@@:@@@@\n", '// @@@@@,@@  @@#,,,,,,,:@,,@@@@@@: @@@@ #:;+::::;@@@@@@@      @@#@@       @@@,,@@@@\n', "// ,@@@@,@@  @@@:,,,,,,,,,@@@@@@@;+   `@;;:;::::;;@@@@@     `@@,'@@+     #@@#,,+@@,\n", '// ,,@@,,@@ ,@@@@,,,,,,,,:@@@@@@:::::::::;+##:;;;;::++ ,   @@@,@++++++#@ @@@:,,,@,,\n', "// ,,,,,@@+ @@@@@,,,,,,,+''@@@#;;:::::;:;:::;@  ..`   @@  @@@,,@,;@@@+,@.,@@,,,,,,,\n", "// ,,,,,@@@ @@@@@,,,,,,:+''@'@;::;;:;;:::::::@       @@@ @#@,,,#,......@,,         \n", "// ,,,,,@@@#@@@@@,,,,,,,'''@'@;;;@;@;::::::;;'@     .@@@@#@,,  @,......@'          \n", "// ,,,,,'@@@@@,@@,,,,,::+''@'@;;;+;@;:::::::;;'     '@@:@@;    @:....,.@           \n", "// ,,,,,,@@@@@,@@::::::,@''@''';;:+;#:::;:::;+:,    :@@,,@,,                       \n", "// ,,,,,,:@@@,,@@:::::::@''''+@';;;#;'@@@@@'#:#@#   `@@:,,,,,,,,,,.,,,,,,,,,,,,,,,,\n", "// ,,,,,,,+@,,,@@;;;;'',:@''''''@#;;;;;#@;;@''#:; , `@@+,,,,,,,,,,,,,,,,,,,,,,,,,,,\n", "// ,,,,@,,,:,,:@@::::,,::::@''''''''''''@;::#@@;:;;@.@@#,,,,,,,,,,,.,,@@,,,,,,,,,,@\n", '// ,,,,;,,,,,,:@@::::@@,:::,@@@####@@@@@@;:;;#@#@@  @@@,,,,,,,,@@@@##@@@########@@@\n', "// ,,,,:,,,,,,,@@'::@@@:::::::#''+++++@@@##@@@@@@@#@@@@,,,@@,,,@@@@@@@@@#######@@@@\n", "// ,,,,,,,,,,,,@@@,@@@@@:,::::+''+::,,@@@'':+@@@:::@@,,;@:@,,,,@@@@@@@@@######@@@@:\n", "// ,,;,,+,,,,,,,@@@@@'@@,:,@,,,''+::::@@@'':'@@@::,:::::,@#+:,#@@@@@@@@#####@@@@@+,\n", "// ,,+,,@,,#,@,,,@@@@,@@@,@@:::''+:::,@@@''::@@@::::::::::::@@@#@+,@@@@####@@@@@@,,\n", "// ,,,,,;,,:,,,,,,@@@,,@@@@@:::'''::::@@@'',:@@@:::::::,::#@@@@@,,,@@@@##@@@@@@@,,,\n", "// ,,,,,,',,#,;,,,,:@,,,#@@@:::#@:::::,:@''::@@,::::::::;@@@@@;,,,,@@@@@@@@@@@:,,,,\n", '// ,,,,,,,,,,,,,,,,,,,,,,,@##:,,::::::::,::::::::::::::,@@@#@:,,,,,:@@@@@@@@,,,,,,,\n', "// ,,,,,,,,,,,,,,,,,,,,,,,'@:::::::::::,::::::::::::::,@@@@@@,,,,,,,,'@@@@,,,,,,,,,\n", '// ,,,,,,,,,,,,,,,,,,,,,:@::::::::::::::::::::::::::::,@@@@@,,,,,,,,,,,;#,,,,,,,,,,\n', '\n', 'import "./ERC20.sol";\n', '\n', 'contract ThisIsFine is ERC20Detailed {\n', '\n', '   using SafeMath for uint256;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => uint256) private _adminBalances;\n', '    mapping (address => mapping (address => uint256)) private _allowed;\n', '    \n', '    string constant tokenName = "This is Fine: an announced rug";\n', '    string constant tokenSymbol = "TIF";\n', '    uint8  constant tokenDecimals = 18;\n', '    \n', '    uint256 _totalSupply = 100000000000000000000; // 100 TIF total supply\n', '    uint256 _OwnerSupply = 100000000000000000000; // All supply is going to the contractOwner\n', '    \n', '    uint256 public burnPercent = 200; // 2% deflation each Tx\n', '    \n', '    uint256 private _releaseTime = 0;\n', '    uint256 private _released;\n', '\n', '    address public contractOwner;\n', '\n', '\n', '    constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {\n', '        _released = block.timestamp+_releaseTime;\n', '\t\t    contractOwner = msg.sender;\n', '        _mint(msg.sender, _OwnerSupply);\n', '    }\n', '\n', '    modifier isOwner(){\n', '       require(msg.sender == contractOwner, "Unauthorised Sender");\n', '        _;\n', '    }\n', '   /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '  /**\n', '  * @dev Returns when the Admin Funds will be released in seconds\n', '  */\n', '  function released() public view returns (uint256) {\n', '    return _released;\n', '  }\n', '    \n', '  /**\n', '  * @dev Gets the Admin balance of the specified address.\n', '  * @param adminAddress The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function adminBalance(address adminAddress) public view returns(uint256) {\n', '      return _adminBalances[adminAddress];\n', '  }\n', '  \n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param user The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address user) public view returns (uint256) {\n', '    return _balances[user];\n', '  }\n', '\n', ' //Finding the percent of the burnfee\n', '  function findBurnPercent(uint256 value) internal view returns (uint256)  {\n', '\t//Burn 1% of the sellers tokens\n', '\tuint256 burnValue = value.ceil(1);\n', '\tuint256 onePercent = burnValue.mul(burnPercent).div(10000);\n', '\n', '\treturn onePercent;\n', '  }\n', '  \n', '  \n', '  \n', '  //Simple transfer Does not burn tokens when transfering only allowed by Owner\n', '  function simpleTransfer(address to, uint256 value) public isOwner returns (bool) {\n', '\trequire(value <= _balances[msg.sender]);\n', '\trequire(to != address(0));\n', '\n', '\t_balances[msg.sender] = _balances[msg.sender].sub(value);\n', '\t_balances[to] = _balances[to].add(value);\n', '\n', '\temit Transfer(msg.sender, to, value);\n', '\treturn true;\n', '  }\n', ' \n', '    //Send Locked token to contract only Owner Can do so its pointless for anyone else\n', '    function sendLockedToken(address beneficiary, uint256 value) public isOwner{\n', '        require(_released > block.timestamp, "TokenTimelock: release time is before current time");\n', '\t\trequire(value <= _balances[msg.sender]);\n', '\t\t_balances[msg.sender] = _balances[msg.sender].sub(value);\n', '\t\t_adminBalances[beneficiary] = value;\n', '    }\n', '    \n', '    //Anyone Can Release The Funds after 2 months\n', '    function release() public returns(bool){\n', '        require(block.timestamp >= _released, "TokenTimelock: current time is before release time");\n', '        uint256 value = _adminBalances[msg.sender];\n', '        require(value > 0, "TokenTimelock: no tokens to release");\n', '        _balances[msg.sender] = _balances[msg.sender].add(value);\n', '         emit Transfer(contractOwner , msg.sender, value);\n', '\t\t return true;\n', '    }\n', '  \n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  //To be Used by users to trasnfer tokens and burn while doing so\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender],"Not Enough Tokens in Account");\n', '    require(to != address(0));\n', '\tuint256 burn;\n', '    burn = findBurnPercent(value);\n', '\t\n', '    uint256 tokensToTransfer = value.sub(burn);\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '\n', '    _totalSupply = _totalSupply.sub(burn);\n', '\n', '    emit Transfer(msg.sender, to, tokensToTransfer);\n', '    emit Transfer(msg.sender, address(0), burn);\n', '    return true;\n', '  }\n', '  \n', '  //Transfer tokens to multiple addresses at once\n', '  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '      transfer(receivers[i], amounts[i]);\n', '    }\n', '  }\n', '   /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param amount The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function burn(uint256 amount) external {\n', '     require(amount <= _balances[msg.sender],"Not Enough Tokens in Account");\n', '    _burn(msg.sender, amount);\n', '  }\n', ' /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be Deflationary.\n', '   * @param amount The amount that will be Deflationary.\n', '   */\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(amount != 0);\n', '    require(amount <= _balances[account]);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be Deflationary.\n', '   * @param amount The amount that will be Deflationary.\n', '   */\t\n', '  function burnFrom(address account, uint256 amount) external {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);\n', '    _burn(account, amount);\n', '  }\n', '  \n', '    /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address owner, address spender) public view returns (uint256) {\n', '    return _allowed[owner][spender];\n', '  }\n', ' \n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '   /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '    \n', '    //Delete balance of this account\n', '    _balances[from] = _balances[from].sub(value);\n', '    \n', '\tuint256 burn;\n', '\tburn = findBurnPercent(value);\n', '\n', '    uint256 tokensToTransfer = value.sub(burn);\n', '\n', '    _balances[to] = _balances[to].add(tokensToTransfer);\n', '    _totalSupply = _totalSupply.sub(burn);\n', '\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '\n', '    emit Transfer(from, to, tokensToTransfer);\n', '    emit Transfer(from, address(0), burn);\n', '    return true;\n', '  }\n', '   /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {\n', '    require(spender != address(0));\n', '    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '}']
['pragma solidity ^0.5.0;\n', '\n', '\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function approve(address spender, uint256 value) external returns (bool);\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', ' \n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '}\n', '\n', 'contract ERC20Detailed is IERC20 {\n', '\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(string memory name, string memory symbol, uint8 decimals) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '   /**\n', '   * @return the name of the token.\n', '   */\n', '  function name() public view returns(string memory) {\n', '    return _name;\n', '  }\n', '  /**\n', '   * @return the symbol of the token.\n', '   */\n', '  function symbol() public view returns(string memory) {\n', '    return _symbol;\n', '  }\n', '  /**\n', '   * @return the number of decimals of the token.\n', '   */\n', '  function decimals() public view returns(uint8) {\n', '    return _decimals;\n', '  }\n', '}\n']