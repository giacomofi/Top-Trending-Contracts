['pragma solidity ^0.4.23;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Autonomy is Ownable {\n', '    address public congress;\n', '    bool init = false;\n', '\n', '    modifier onlyCongress() {\n', '        require(msg.sender == congress);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev initialize a Congress contract address for this token \n', '     *\n', '     * @param _congress address the congress contract address\n', '     */\n', '    function initialCongress(address _congress) onlyOwner public {\n', '        require(!init);\n', '        require(_congress != address(0));\n', '        congress = _congress;\n', '        init = true;\n', '    }\n', '\n', '    /**\n', '     * @dev set a Congress contract address for this token\n', '     * must change this address by the last congress contract \n', '     *\n', '     * @param _congress address the congress contract address\n', '     */\n', '    function changeCongress(address _congress) onlyCongress public {\n', '        require(_congress != address(0));\n', '        congress = _congress;\n', '    }\n', '}\n', '\n', 'contract Destructible is Ownable {\n', '\n', '  function Destructible() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract DRCWalletMgrParams is Claimable, Autonomy, Destructible {\n', '    uint256 public singleWithdrawMin; // min value of single withdraw\n', '    uint256 public singleWithdrawMax; // Max value of single withdraw\n', '    uint256 public dayWithdraw; // Max value of one day of withdraw\n', '    uint256 public monthWithdraw; // Max value of one month of withdraw\n', '    uint256 public dayWithdrawCount; // Max number of withdraw counting\n', '\n', '    uint256 public chargeFee; // the charge fee for withdraw\n', '    address public chargeFeePool; // the address that will get the returned charge fees.\n', '\n', '\n', '    function initialSingleWithdrawMax(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        singleWithdrawMax = _value;\n', '    }\n', '\n', '    function initialSingleWithdrawMin(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        singleWithdrawMin = _value;\n', '    }\n', '\n', '    function initialDayWithdraw(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        dayWithdraw = _value;\n', '    }\n', '\n', '    function initialDayWithdrawCount(uint256 _count) onlyOwner public {\n', '        require(!init);\n', '\n', '        dayWithdrawCount = _count;\n', '    }\n', '\n', '    function initialMonthWithdraw(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        monthWithdraw = _value;\n', '    }\n', '\n', '    function initialChargeFee(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        chargeFee = _value;\n', '    }\n', '\n', '    function initialChargeFeePool(address _pool) onlyOwner public {\n', '        require(!init);\n', '\n', '        chargeFeePool = _pool;\n', '    }    \n', '\n', '    function setSingleWithdrawMax(uint256 _value) onlyCongress public {\n', '        singleWithdrawMax = _value;\n', '    }   \n', '\n', '    function setSingleWithdrawMin(uint256 _value) onlyCongress public {\n', '        singleWithdrawMin = _value;\n', '    }\n', '\n', '    function setDayWithdraw(uint256 _value) onlyCongress public {\n', '        dayWithdraw = _value;\n', '    }\n', '\n', '    function setDayWithdrawCount(uint256 _count) onlyCongress public {\n', '        dayWithdrawCount = _count;\n', '    }\n', '\n', '    function setMonthWithdraw(uint256 _value) onlyCongress public {\n', '        monthWithdraw = _value;\n', '    }\n', '\n', '    function setChargeFee(uint256 _value) onlyCongress public {\n', '        chargeFee = _value;\n', '    }\n', '\n', '    function setChargeFeePool(address _pool) onlyCongress public {\n', '        chargeFeePool = _pool;\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract Autonomy is Ownable {\n', '    address public congress;\n', '    bool init = false;\n', '\n', '    modifier onlyCongress() {\n', '        require(msg.sender == congress);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev initialize a Congress contract address for this token \n', '     *\n', '     * @param _congress address the congress contract address\n', '     */\n', '    function initialCongress(address _congress) onlyOwner public {\n', '        require(!init);\n', '        require(_congress != address(0));\n', '        congress = _congress;\n', '        init = true;\n', '    }\n', '\n', '    /**\n', '     * @dev set a Congress contract address for this token\n', '     * must change this address by the last congress contract \n', '     *\n', '     * @param _congress address the congress contract address\n', '     */\n', '    function changeCongress(address _congress) onlyCongress public {\n', '        require(_congress != address(0));\n', '        congress = _congress;\n', '    }\n', '}\n', '\n', 'contract Destructible is Ownable {\n', '\n', '  function Destructible() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    emit OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract DRCWalletMgrParams is Claimable, Autonomy, Destructible {\n', '    uint256 public singleWithdrawMin; // min value of single withdraw\n', '    uint256 public singleWithdrawMax; // Max value of single withdraw\n', '    uint256 public dayWithdraw; // Max value of one day of withdraw\n', '    uint256 public monthWithdraw; // Max value of one month of withdraw\n', '    uint256 public dayWithdrawCount; // Max number of withdraw counting\n', '\n', '    uint256 public chargeFee; // the charge fee for withdraw\n', '    address public chargeFeePool; // the address that will get the returned charge fees.\n', '\n', '\n', '    function initialSingleWithdrawMax(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        singleWithdrawMax = _value;\n', '    }\n', '\n', '    function initialSingleWithdrawMin(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        singleWithdrawMin = _value;\n', '    }\n', '\n', '    function initialDayWithdraw(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        dayWithdraw = _value;\n', '    }\n', '\n', '    function initialDayWithdrawCount(uint256 _count) onlyOwner public {\n', '        require(!init);\n', '\n', '        dayWithdrawCount = _count;\n', '    }\n', '\n', '    function initialMonthWithdraw(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        monthWithdraw = _value;\n', '    }\n', '\n', '    function initialChargeFee(uint256 _value) onlyOwner public {\n', '        require(!init);\n', '\n', '        chargeFee = _value;\n', '    }\n', '\n', '    function initialChargeFeePool(address _pool) onlyOwner public {\n', '        require(!init);\n', '\n', '        chargeFeePool = _pool;\n', '    }    \n', '\n', '    function setSingleWithdrawMax(uint256 _value) onlyCongress public {\n', '        singleWithdrawMax = _value;\n', '    }   \n', '\n', '    function setSingleWithdrawMin(uint256 _value) onlyCongress public {\n', '        singleWithdrawMin = _value;\n', '    }\n', '\n', '    function setDayWithdraw(uint256 _value) onlyCongress public {\n', '        dayWithdraw = _value;\n', '    }\n', '\n', '    function setDayWithdrawCount(uint256 _count) onlyCongress public {\n', '        dayWithdrawCount = _count;\n', '    }\n', '\n', '    function setMonthWithdraw(uint256 _value) onlyCongress public {\n', '        monthWithdraw = _value;\n', '    }\n', '\n', '    function setChargeFee(uint256 _value) onlyCongress public {\n', '        chargeFee = _value;\n', '    }\n', '\n', '    function setChargeFeePool(address _pool) onlyCongress public {\n', '        chargeFeePool = _pool;\n', '    }\n', '}']
