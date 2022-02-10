['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-21\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2019-08-08\n', '*/\n', '\n', '/* ===============================================\n', '* Flattened with Solidifier by Coinage\n', '* \n', '* https://solidifier.coina.ge\n', '* ===============================================\n', '*/\n', '\n', '\n', '/*\n', '-----------------------------------------------------------------\n', 'FILE INFORMATION\n', '-----------------------------------------------------------------\n', '\n', 'file:       Owned.sol\n', 'version:    1.1\n', 'author:     Anton Jurisevic\n', '            Dominic Romanowski\n', '\n', 'date:       2018-2-26\n', '\n', '-----------------------------------------------------------------\n', 'MODULE DESCRIPTION\n', '-----------------------------------------------------------------\n', '\n', 'An Owned contract, to be inherited by other contracts.\n', 'Requires its owner to be explicitly set in the constructor.\n', 'Provides an onlyOwner access modifier.\n', '\n', 'To change owner, the current owner must nominate the next owner,\n', 'who then has to accept the nomination. The nomination can be\n', 'cancelled before it is accepted by the new owner by having the\n', 'previous owner change the nomination (setting it to 0).\n', '\n', '-----------------------------------------------------------------\n', '*/\n', '\n', 'pragma solidity 0.4.25;\n', '\n', '/**\n', ' * @title A contract with an owner.\n', ' * @notice Contract ownership can be transferred by first nominating the new owner,\n', ' * who must then accept the ownership, which prevents accidental incorrect ownership transfers.\n', ' */\n', 'contract Owned {\n', '    address public owner;\n', '    address public nominatedOwner;\n', '\n', '    /**\n', '     * @dev Owned Constructor\n', '     */\n', '    constructor(address _owner)\n', '        public\n', '    {\n', '        require(_owner != address(0), "Owner address cannot be 0");\n', '        owner = _owner;\n', '        emit OwnerChanged(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @notice Nominate a new owner of this contract.\n', '     * @dev Only the current owner may nominate a new owner.\n', '     */\n', '    function nominateNewOwner(address _owner)\n', '        external\n', '        onlyOwner\n', '    {\n', '        nominatedOwner = _owner;\n', '        emit OwnerNominated(_owner);\n', '    }\n', '\n', '    /**\n', '     * @notice Accept the nomination to be owner.\n', '     */\n', '    function acceptOwnership()\n', '        external\n', '    {\n', '        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");\n', '        emit OwnerChanged(owner, nominatedOwner);\n', '        owner = nominatedOwner;\n', '        nominatedOwner = address(0);\n', '    }\n', '\n', '    modifier onlyOwner\n', '    {\n', '        require(msg.sender == owner, "Only the contract owner may perform this action");\n', '        _;\n', '    }\n', '\n', '    event OwnerNominated(address newOwner);\n', '    event OwnerChanged(address oldOwner, address newOwner);\n', '}\n', '\n', '\n', '/*\n', '-----------------------------------------------------------------\n', 'FILE INFORMATION\n', '-----------------------------------------------------------------\n', '\n', 'file:       Proxy.sol\n', 'version:    1.3\n', 'author:     Anton Jurisevic\n', '\n', 'date:       2018-05-29\n', '\n', '-----------------------------------------------------------------\n', 'MODULE DESCRIPTION\n', '-----------------------------------------------------------------\n', '\n', 'A proxy contract that, if it does not recognise the function\n', 'being called on it, passes all value and call data to an\n', 'underlying target contract.\n', '\n', 'This proxy has the capacity to toggle between DELEGATECALL\n', 'and CALL style proxy functionality.\n', '\n', "The former executes in the proxy's context, and so will preserve \n", 'msg.sender and store data at the proxy address. The latter will not.\n', 'Therefore, any contract the proxy wraps in the CALL style must\n', 'implement the Proxyable interface, in order that it can pass msg.sender\n', 'into the underlying contract as the state parameter, messageSender.\n', '\n', '-----------------------------------------------------------------\n', '*/\n', '\n', '\n', 'contract Proxy is Owned {\n', '\n', '    Proxyable public target;\n', '    bool public useDELEGATECALL;\n', '\n', '    constructor(address _owner)\n', '        Owned(_owner)\n', '        public\n', '    {}\n', '\n', '    function setTarget(Proxyable _target)\n', '        external\n', '        onlyOwner\n', '    {\n', '        target = _target;\n', '        emit TargetUpdated(_target);\n', '    }\n', '\n', '    function setUseDELEGATECALL(bool value) \n', '        external\n', '        onlyOwner\n', '    {\n', '        useDELEGATECALL = value;\n', '    }\n', '\n', '    function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)\n', '        external\n', '        onlyTarget\n', '    {\n', '        uint size = callData.length;\n', '        bytes memory _callData = callData;\n', '\n', '        assembly {\n', '            /* The first 32 bytes of callData contain its length (as specified by the abi). \n', '             * Length is assumed to be a uint256 and therefore maximum of 32 bytes\n', '             * in length. It is also leftpadded to be a multiple of 32 bytes.\n', '             * This means moving call_data across 32 bytes guarantees we correctly access\n', '             * the data itself. */\n', '            switch numTopics\n', '            case 0 {\n', '                log0(add(_callData, 32), size)\n', '            } \n', '            case 1 {\n', '                log1(add(_callData, 32), size, topic1)\n', '            }\n', '            case 2 {\n', '                log2(add(_callData, 32), size, topic1, topic2)\n', '            }\n', '            case 3 {\n', '                log3(add(_callData, 32), size, topic1, topic2, topic3)\n', '            }\n', '            case 4 {\n', '                log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)\n', '            }\n', '        }\n', '    }\n', '\n', '    function()\n', '        external\n', '        payable\n', '    {\n', '        if (useDELEGATECALL) {\n', '            assembly {\n', '                /* Copy call data into free memory region. */\n', '                let free_ptr := mload(0x40)\n', '                calldatacopy(free_ptr, 0, calldatasize)\n', '\n', '                /* Forward all gas and call data to the target contract. */\n', '                let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)\n', '                returndatacopy(free_ptr, 0, returndatasize)\n', '\n', '                /* Revert if the call failed, otherwise return the result. */\n', '                if iszero(result) { revert(free_ptr, returndatasize) }\n', '                return(free_ptr, returndatasize)\n', '            }\n', '        } else {\n', '            /* Here we are as above, but must send the messageSender explicitly \n', '             * since we are using CALL rather than DELEGATECALL. */\n', '            target.setMessageSender(msg.sender);\n', '            assembly {\n', '                let free_ptr := mload(0x40)\n', '                calldatacopy(free_ptr, 0, calldatasize)\n', '\n', '                /* We must explicitly forward ether to the underlying contract as well. */\n', '                let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)\n', '                returndatacopy(free_ptr, 0, returndatasize)\n', '\n', '                if iszero(result) { revert(free_ptr, returndatasize) }\n', '                return(free_ptr, returndatasize)\n', '            }\n', '        }\n', '    }\n', '\n', '    modifier onlyTarget {\n', '        require(Proxyable(msg.sender) == target, "Must be proxy target");\n', '        _;\n', '    }\n', '\n', '    event TargetUpdated(Proxyable newTarget);\n', '}\n', '\n', '\n', '/*\n', '-----------------------------------------------------------------\n', 'FILE INFORMATION\n', '-----------------------------------------------------------------\n', '\n', 'file:       Proxyable.sol\n', 'version:    1.1\n', 'author:     Anton Jurisevic\n', '\n', 'date:       2018-05-15\n', '\n', 'checked:    Mike Spain\n', 'approved:   Samuel Brooks\n', '\n', '-----------------------------------------------------------------\n', 'MODULE DESCRIPTION\n', '-----------------------------------------------------------------\n', '\n', 'A proxyable contract that works hand in hand with the Proxy contract\n', 'to allow for anyone to interact with the underlying contract both\n', 'directly and through the proxy.\n', '\n', '-----------------------------------------------------------------\n', '*/\n', '\n', '\n', '// This contract should be treated like an abstract contract\n', 'contract Proxyable is Owned {\n', '    /* The proxy this contract exists behind. */\n', '    Proxy public proxy;\n', '    Proxy public integrationProxy;\n', '\n', '    /* The caller of the proxy, passed through to this contract.\n', '     * Note that every function using this member must apply the onlyProxy or\n', '     * optionalProxy modifiers, otherwise their invocations can use stale values. */\n', '    address messageSender;\n', '\n', '    constructor(address _proxy, address _owner)\n', '        Owned(_owner)\n', '        public\n', '    {\n', '        proxy = Proxy(_proxy);\n', '        emit ProxyUpdated(_proxy);\n', '    }\n', '\n', '    function setProxy(address _proxy)\n', '        external\n', '        onlyOwner\n', '    {\n', '        proxy = Proxy(_proxy);\n', '        emit ProxyUpdated(_proxy);\n', '    }\n', '\n', '    function setIntegrationProxy(address _integrationProxy)\n', '        external\n', '        onlyOwner\n', '    {\n', '        integrationProxy = Proxy(_integrationProxy);\n', '    }\n', '\n', '    function setMessageSender(address sender)\n', '        external\n', '        onlyProxy\n', '    {\n', '        messageSender = sender;\n', '    }\n', '\n', '    modifier onlyProxy {\n', '        require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");\n', '        _;\n', '    }\n', '\n', '    modifier optionalProxy\n', '    {\n', '        if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {\n', '            messageSender = msg.sender;\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier optionalProxy_onlyOwner\n', '    {\n', '        if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {\n', '            messageSender = msg.sender;\n', '        }\n', '        require(messageSender == owner, "Owner only function");\n', '        _;\n', '    }\n', '\n', '    event ProxyUpdated(address proxyAddress);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract IERC20 {\n', '    function totalSupply() public view returns (uint);\n', '\n', '    function balanceOf(address owner) public view returns (uint);\n', '\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '\n', '    function transfer(address to, uint value) public returns (bool);\n', '\n', '    function approve(address spender, uint value) public returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint value) public returns (bool);\n', '\n', '    // ERC20 Optional\n', '    function name() public view returns (string);\n', '    function symbol() public view returns (string);\n', '    function decimals() public view returns (uint8);\n', '\n', '    event Transfer(\n', '      address indexed from,\n', '      address indexed to,\n', '      uint value\n', '    );\n', '\n', '    event Approval(\n', '      address indexed owner,\n', '      address indexed spender,\n', '      uint value\n', '    );\n', '}\n', '\n', '\n', '/*\n', '-----------------------------------------------------------------\n', 'FILE INFORMATION\n', '-----------------------------------------------------------------\n', '\n', 'file:       ProxyERC20.sol\n', 'version:    1.0\n', 'author:     Jackson Chan, Clinton Ennis\n', '\n', 'date:       2019-06-19\n', '\n', '-----------------------------------------------------------------\n', 'MODULE DESCRIPTION\n', '-----------------------------------------------------------------\n', '\n', 'A proxy contract that is ERC20 compliant for the Synthetix Network.\n', '\n', 'If it does not recognise a function being called on it, passes all\n', 'value and call data to an underlying target contract.\n', '\n', 'The ERC20 standard has been explicitly implemented to ensure\n', 'contract to contract calls are compatable on MAINNET\n', '\n', '-----------------------------------------------------------------\n', '*/\n', '\n', '\n', 'contract ProxyERC20 is Proxy, IERC20 {\n', '\n', '    constructor(address _owner)\n', '        Proxy(_owner)\n', '        public\n', '    {}\n', '\n', '    // ------------- ERC20 Details ------------- //\n', '\n', '    function name() public view returns (string){\n', '        // Immutable static call from target contract\n', '        return IERC20(target).name();\n', '    }\n', '\n', '    function symbol() public view returns (string){\n', '         // Immutable static call from target contract\n', '        return IERC20(target).symbol();\n', '    }\n', '\n', '    function decimals() public view returns (uint8){\n', '         // Immutable static call from target contract\n', '        return IERC20(target).decimals();\n', '    }\n', '\n', '    // ------------- ERC20 Interface ------------- //\n', '\n', '    /**\n', '    * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        // Immutable static call from target contract\n', '        return IERC20(target).totalSupply();\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param owner The address to query the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address owner) public view returns (uint256) {\n', '        // Immutable static call from target contract\n', '        return IERC20(target).balanceOf(owner);\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param owner address The address which owns the funds.\n', '    * @param spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // Immutable static call from target contract\n', '        return IERC20(target).allowance(owner, spender);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer token for a specified address\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    */\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        // Mutable state call requires the proxy to tell the target who the msg.sender is.\n', '        target.setMessageSender(msg.sender);\n', '\n', '        // Forward the ERC20 call to the target contract\n', '        IERC20(target).transfer(to, value);\n', '\n', '        // Event emitting will occur via Synthetix.Proxy._emit()\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param spender The address which will spend the funds.\n', '    * @param value The amount of tokens to be spent.\n', '    */\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        // Mutable state call requires the proxy to tell the target who the msg.sender is.\n', '        target.setMessageSender(msg.sender);\n', '\n', '        // Forward the ERC20 call to the target contract\n', '        IERC20(target).approve(spender, value);\n', '\n', '        // Event emitting will occur via Synthetix.Proxy._emit()\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param from address The address which you want to send tokens from\n', '    * @param to address The address which you want to transfer to\n', '    * @param value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        // Mutable state call requires the proxy to tell the target who the msg.sender is.\n', '        target.setMessageSender(msg.sender);\n', '\n', '        // Forward the ERC20 call to the target contract\n', '        IERC20(target).transferFrom(from, to, value);\n', '\n', '        // Event emitting will occur via Synthetix.Proxy._emit()\n', '        return true;\n', '    }\n', '}']