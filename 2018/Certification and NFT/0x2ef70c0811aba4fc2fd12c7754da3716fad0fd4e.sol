['pragma solidity ^0.4.21;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Whitelist\n', ' * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.\n', ' * @dev This simplifies the implementation of "user permissions".\n', ' */\n', 'contract Whitelist is Ownable {\n', '  mapping(address => bool) public whitelist;\n', '\n', '  event WhitelistedAddressAdded(address addr);\n', '  event WhitelistedAddressRemoved(address addr);\n', '\n', '  /**\n', '   * @dev Throws if called by any account that&#39;s not whitelisted.\n', '   */\n', '  modifier onlyWhitelisted() {\n', '    require(whitelist[msg.sender]);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev add an address to the whitelist\n', '   * @param addr address\n', '   * @return true if the address was added to the whitelist, false if the address was already in the whitelist\n', '   */\n', '  function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {\n', '    if (!whitelist[addr]) {\n', '      whitelist[addr] = true;\n', '      emit WhitelistedAddressAdded(addr);\n', '      success = true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev add addresses to the whitelist\n', '   * @param addrs addresses\n', '   * @return true if at least one address was added to the whitelist,\n', '   * false if all addresses were already in the whitelist\n', '   */\n', '  function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {\n', '    for (uint256 i = 0; i < addrs.length; i++) {\n', '      if (addAddressToWhitelist(addrs[i])) {\n', '        success = true;\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev remove an address from the whitelist\n', '   * @param addr address\n', '   * @return true if the address was removed from the whitelist,\n', '   * false if the address wasn&#39;t in the whitelist in the first place\n', '   */\n', '  function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {\n', '    if (whitelist[addr]) {\n', '      whitelist[addr] = false;\n', '      emit WhitelistedAddressRemoved(addr);\n', '      success = true;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev remove addresses from the whitelist\n', '   * @param addrs addresses\n', '   * @return true if at least one address was removed from the whitelist,\n', '   * false if all addresses weren&#39;t in the whitelist in the first place\n', '   */\n', '  function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {\n', '    for (uint256 i = 0; i < addrs.length; i++) {\n', '      if (removeAddressFromWhitelist(addrs[i])) {\n', '        success = true;\n', '      }\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'contract BuyLimits {\n', '    event LogLimitsChanged(uint _minBuy, uint _maxBuy);\n', '\n', '    // Variables holding the min and max payment in wei\n', '    uint public minBuy; // min buy in wei\n', '    uint public maxBuy; // max buy in wei, 0 means no maximum\n', '\n', '    /*\n', '    ** Modifier, reverting if not within limits.\n', '    */\n', '    modifier isWithinLimits(uint _amount) {\n', '        require(withinLimits(_amount));\n', '        _;\n', '    }\n', '\n', '    /*\n', '    ** @dev Constructor, define variable:\n', '    */\n', '    function BuyLimits(uint _min, uint  _max) public {\n', '        _setLimits(_min, _max);\n', '    }\n', '\n', '    /*\n', '    ** @dev Check TXs value is within limits:\n', '    */\n', '    function withinLimits(uint _value) public view returns(bool) {\n', '        if (maxBuy != 0) {\n', '            return (_value >= minBuy && _value <= maxBuy);\n', '        }\n', '        return (_value >= minBuy);\n', '    }\n', '\n', '    /*\n', '    ** @dev set limits logic:\n', '    ** @param _min set the minimum buy in wei\n', '    ** @param _max set the maximum buy in wei, 0 indeicates no maximum\n', '    */\n', '    function _setLimits(uint _min, uint _max) internal {\n', '        if (_max != 0) {\n', '            require (_min <= _max); // Sanity Check\n', '        }\n', '        minBuy = _min;\n', '        maxBuy = _max;\n', '        emit LogLimitsChanged(_min, _max);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title DAOstackPresale\n', ' * @dev A contract to allow only whitelisted followers to participate in presale.\n', ' */\n', 'contract DAOstackPreSale is Pausable,BuyLimits,Whitelist {\n', '    event LogFundsReceived(address indexed _sender, uint _amount);\n', '\n', '    address public wallet;\n', '\n', '    /**\n', '    * @dev Constructor.\n', '    * @param _wallet Address where the funds are transfered to\n', '    * @param _minBuy Address where the funds are transfered to\n', '    * @param _maxBuy Address where the funds are transfered to\n', '    */\n', '    function DAOstackPreSale(address _wallet, uint _minBuy, uint _maxBuy)\n', '    public\n', '    BuyLimits(_minBuy, _maxBuy)\n', '    {\n', '        // Set wallet:\n', '        require(_wallet != address(0));\n', '        wallet = _wallet;\n', '    }\n', '\n', '    /**\n', '    * @dev Fallback, funds coming in are transfered to wallet\n', '    */\n', '    function () payable whenNotPaused onlyWhitelisted isWithinLimits(msg.value) external {\n', '        wallet.transfer(msg.value);\n', '        emit LogFundsReceived(msg.sender, msg.value);\n', '    }\n', '\n', '    /*\n', '    ** @dev Drain function, in case of failure. Contract should not hold eth anyhow.\n', '    */\n', '    function drain() external {\n', '        wallet.transfer((address(this)).balance);\n', '    }\n', '\n', '}']