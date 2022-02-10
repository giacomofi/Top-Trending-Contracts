['pragma solidity ^0.5.0;\n', '\n', 'contract Lock {\n', '    // address owner; slot #0\n', '    // address unlockTime; slot #1\n', '    constructor (address owner, uint256 unlockTime) public payable {\n', '        assembly {\n', '            sstore(0x00, owner)\n', '            sstore(0x01, unlockTime)\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * @dev        Withdraw function once timestamp has passed unlock time\n', '     */\n', "    function () external payable { // payable so solidity doesn't add unnecessary logic\n", '        assembly {\n', '            switch gt(timestamp, sload(0x01))\n', '            case 0 { revert(0, 0) }\n', '            case 1 {\n', '                switch call(gas, sload(0x00), balance(address), 0, 0, 0, 0)\n', '                case 0 { revert(0, 0) }\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract Lockdrop {\n', '    enum Term {\n', '        ThreeMo,\n', '        SixMo,\n', '        TwelveMo\n', '    }\n', '    // Time constants\n', '    uint256 constant public LOCK_DROP_PERIOD = 1 days * 92; // 3 months\n', '    uint256 public LOCK_START_TIME;\n', '    uint256 public LOCK_END_TIME;\n', '    // ETH locking events\n', '    event Locked(address indexed owner, uint256 eth, Lock lockAddr, Term term, bytes edgewareAddr, bool isValidator, uint time);\n', '    event Signaled(address indexed contractAddr, bytes edgewareAddr, uint time);\n', '    \n', '    constructor(uint startTime) public {\n', '        LOCK_START_TIME = startTime;\n', '        LOCK_END_TIME = startTime + LOCK_DROP_PERIOD;\n', '    }\n', '\n', '    /**\n', '     * @dev        Locks up the value sent to contract in a new Lock\n', '     * @param      term         The length of the lock up\n', '     * @param      edgewareAddr The bytes representation of the target edgeware key\n', '     * @param      isValidator  Indicates if sender wishes to be a validator\n', '     */\n', '    function lock(Term term, bytes calldata edgewareAddr, bool isValidator)\n', '        external\n', '        payable\n', '        didStart\n', '        didNotEnd\n', '    {\n', '        uint256 eth = msg.value;\n', '        address owner = msg.sender;\n', '        uint256 unlockTime = unlockTimeForTerm(term);\n', '        // Create ETH lock contract\n', '        Lock lockAddr = (new Lock).value(eth)(owner, unlockTime);\n', '        // ensure lock contract has at least all the ETH, or fail\n', '        assert(address(lockAddr).balance >= msg.value);\n', '        emit Locked(owner, eth, lockAddr, term, edgewareAddr, isValidator, now);\n', '    }\n', '\n', '    /**\n', "     * @dev        Signals a contract's (or address's) balance decided after lock period\n", '     * @param      contractAddr  The contract address from which to signal the balance of\n', '     * @param      nonce         The transaction nonce of the creator of the contract\n', '     * @param      edgewareAddr   The bytes representation of the target edgeware key\n', '     */\n', '    function signal(address contractAddr, uint32 nonce, bytes calldata edgewareAddr)\n', '        external\n', '        didStart\n', '        didNotEnd\n', '        didCreate(contractAddr, msg.sender, nonce)\n', '    {\n', '        emit Signaled(contractAddr, edgewareAddr, now);\n', '    }\n', '\n', '    function unlockTimeForTerm(Term term) internal view returns (uint256) {\n', '        if (term == Term.ThreeMo) return now + 92 days;\n', '        if (term == Term.SixMo) return now + 183 days;\n', '        if (term == Term.TwelveMo) return now + 365 days;\n', '        \n', '        revert();\n', '    }\n', '\n', '    /**\n', '     * @dev        Ensures the lockdrop has started\n', '     */\n', '    modifier didStart() {\n', '        require(now >= LOCK_START_TIME);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev        Ensures the lockdrop has not ended\n', '     */\n', '    modifier didNotEnd() {\n', '        require(now <= LOCK_END_TIME);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev        Rebuilds the contract address from a normal address and transaction nonce\n', "     * @param      _origin  The non-contract address derived from a user's public key\n", '     * @param      _nonce   The transaction nonce from which to generate a contract address\n', '     */\n', '    function addressFrom(address _origin, uint32 _nonce) public pure returns (address) {\n', '        if(_nonce == 0x00)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, byte(0x80))))));\n', '        if(_nonce <= 0x7f)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, uint8(_nonce))))));\n', '        if(_nonce <= 0xff)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd7), byte(0x94), _origin, byte(0x81), uint8(_nonce))))));\n', '        if(_nonce <= 0xffff)   return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd8), byte(0x94), _origin, byte(0x82), uint16(_nonce))))));\n', '        if(_nonce <= 0xffffff) return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd9), byte(0x94), _origin, byte(0x83), uint24(_nonce))))));\n', '        return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xda), byte(0x94), _origin, byte(0x84), uint32(_nonce)))))); // more than 2^32 nonces not realistic\n', '    }\n', '\n', '    /**\n', '     * @dev        Ensures the target address was created by a parent at some nonce\n', '     * @param      target  The target contract address (or trivially the parent)\n', '     * @param      parent  The creator of the alleged contract address\n', "     * @param      nonce   The creator's tx nonce at the time of the contract creation\n", '     */\n', '    modifier didCreate(address target, address parent, uint32 nonce) {\n', '        // Trivially let senders "create" themselves\n', '        if (target == parent) {\n', '            _;\n', '        } else {\n', '            require(target == addressFrom(parent, nonce));\n', '            _;\n', '        }\n', '    }\n', '}']