['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract TokenRecipient {\n', '    event ReceivedEther(address indexed sender, uint amount);\n', '    event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);\n', '\n', '    /**\n', '     * @dev Receive tokens and generate a log event\n', '     * @param from Address from which to transfer tokens\n', '     * @param value Amount of tokens to transfer\n', '     * @param token Address of token\n', '     * @param extraData Additional data to log\n', '     */\n', '    function receiveApproval(address from, uint256 value, address token, bytes extraData) public {\n', '        ERC20 t = ERC20(token);\n', '        require(t.transferFrom(from, this, value));\n', '        ReceivedTokens(from, value, token, extraData);\n', '    }\n', '\n', '    /**\n', '     * @dev Receive Ether and generate a log event\n', '     */\n', '    function () payable public {\n', '        ReceivedEther(msg.sender, msg.value);\n', '    }\n', '}\n', '\n', 'contract AuthenticatedProxy is TokenRecipient {\n', '\n', '    /* Address which owns this proxy. */\n', '    address public user;\n', '\n', '    /* Associated registry with contract authentication information. */\n', '    ProxyRegistry public registry;\n', '\n', '    /* Whether access has been revoked. */\n', '    bool public revoked;\n', '\n', '    /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */\n', '    enum HowToCall { Call, DelegateCall }\n', '\n', '    /* Event fired when the proxy access is revoked or unrevoked. */\n', '    event Revoked(bool revoked);\n', '\n', '    /**\n', '     * Create an AuthenticatedProxy\n', '     *\n', '     * @param addrUser Address of user on whose behalf this proxy will act\n', '     * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy\n', '     */\n', '    function AuthenticatedProxy(address addrUser, ProxyRegistry addrRegistry) public {\n', '        user = addrUser;\n', '        registry = addrRegistry;\n', '    }\n', '\n', '    /**\n', '     * Set the revoked flag (allows a user to revoke ProxyRegistry access)\n', '     *\n', '     * @dev Can be called by the user only\n', '     * @param revoke Whether or not to revoke access\n', '     */\n', '    function setRevoke(bool revoke)\n', '        public\n', '    {\n', '        require(msg.sender == user);\n', '        revoked = revoke;\n', '        Revoked(revoke);\n', '    }\n', '\n', '    /**\n', '     * Execute a message call from the proxy contract\n', '     *\n', '     * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access\n', '     * @param dest Address to which the call will be sent\n', '     * @param howToCall Which kind of call to make\n', '     * @param calldata Calldata to send\n', '     * @return Result of the call (success or failure)\n', '     */\n', '    function proxy(address dest, HowToCall howToCall, bytes calldata)\n', '        public\n', '        returns (bool result)\n', '    {\n', '        require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));\n', '        if (howToCall == HowToCall.Call) {\n', '            result = dest.call(calldata);\n', '        } else if (howToCall == HowToCall.DelegateCall) {\n', '            result = dest.delegatecall(calldata);\n', '        }\n', '        return result;\n', '    }\n', '\n', '    /**\n', '     * Execute a message call and assert success\n', '     * \n', '     * @dev Same functionality as `proxy`, just asserts the return value\n', '     * @param dest Address to which the call will be sent\n', '     * @param howToCall What kind of call to make\n', '     * @param calldata Calldata to send\n', '     */\n', '    function proxyAssert(address dest, HowToCall howToCall, bytes calldata)\n', '        public\n', '    {\n', '        require(proxy(dest, howToCall, calldata));\n', '    }\n', '\n', '}\n', '\n', 'contract ProxyRegistry is Ownable {\n', '\n', '    /* Authenticated proxies by user. */\n', '    mapping(address => AuthenticatedProxy) public proxies;\n', '\n', '    /* Contracts pending access. */\n', '    mapping(address => uint) public pending;\n', '\n', '    /* Contracts allowed to call those proxies. */\n', '    mapping(address => bool) public contracts;\n', '\n', '    /* Delay period for adding an authenticated contract.\n', '       This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),\n', '       a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have\n', '       plenty of time to notice and transfer their assets.\n', '    */\n', '    uint public DELAY_PERIOD = 2 weeks;\n', '\n', '    /**\n', '     * Start the process to enable access for specified contract. Subject to delay period.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address to which to grant permissions\n', '     */\n', '    function startGrantAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(!contracts[addr] && pending[addr] == 0);\n', '        pending[addr] = now;\n', '    }\n', '\n', '    /**\n', '     * End the process to nable access for specified contract after delay period has passed.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address to which to grant permissions\n', '     */\n', '    function endGrantAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));\n', '        pending[addr] = 0;\n', '        contracts[addr] = true;\n', '    }\n', '\n', '    /**\n', '     * Revoke access for specified contract. Can be done instantly.\n', '     *\n', '     * @dev ProxyRegistry owner only\n', '     * @param addr Address of which to revoke permissions\n', '     */    \n', '    function revokeAuthentication (address addr)\n', '        public\n', '        onlyOwner\n', '    {\n', '        contracts[addr] = false;\n', '    }\n', '\n', '    /**\n', '     * Register a proxy contract with this registry\n', '     *\n', '     * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy\n', '     * @return New AuthenticatedProxy contract\n', '     */\n', '    function registerProxy()\n', '        public\n', '        returns (AuthenticatedProxy proxy)\n', '    {\n', '        require(proxies[msg.sender] == address(0));\n', '        proxy = new AuthenticatedProxy(msg.sender, this);\n', '        proxies[msg.sender] = proxy;\n', '        return proxy;\n', '    }\n', '\n', '}\n', '\n', 'contract TokenTransferProxy {\n', '\n', '    /* Authentication registry. */\n', '    ProxyRegistry public registry;\n', '\n', '    /**\n', '     * Call ERC20 `transferFrom`\n', '     *\n', '     * @dev Authenticated contract only\n', '     * @param token ERC20 token address\n', '     * @param from From address\n', '     * @param to To address\n', '     * @param amount Transfer amount\n', '     */\n', '    function transferFrom(address token, address from, address to, uint amount)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(registry.contracts(msg.sender));\n', '        return ERC20(token).transferFrom(from, to, amount);\n', '    }\n', '\n', '}\n', '\n', 'contract WyvernTokenTransferProxy is TokenTransferProxy {\n', '\n', '    function WyvernTokenTransferProxy (ProxyRegistry registryAddr)\n', '        public\n', '    {\n', '        registry = registryAddr;\n', '    }\n', '\n', '}']