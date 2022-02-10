['pragma solidity ^0.4.18;\n', '\n', '    /**\n', '    * Math operations with safety checks\n', '    */\n', '    library SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '    }\n', '\n', '\n', '    contract Owned {\n', '\n', '        /// @dev `owner` is the only address that can call a function with this\n', '        /// modifier\n', '        modifier onlyOwner() {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '\n', '        address public owner;\n', '        /// @notice The Constructor assigns the message sender to be `owner`\n', '        function Owned() public {\n', '            owner = msg.sender;\n', '        }\n', '\n', '        address public newOwner;\n', '\n', '        /// @notice `owner` can step down and assign some other address to this role\n', '        /// @param _newOwner The address of the new owner. 0x0 can be used to create\n', '        ///  an unowned neutral vault, however that cannot be undone\n', '        function changeOwner(address _newOwner) onlyOwner public {\n', '            newOwner = _newOwner;\n', '        }\n', '\n', '\n', '        function acceptOwnership() public {\n', '            if (msg.sender == newOwner) {\n', '                owner = newOwner;\n', '            }\n', '        }\n', '    }\n', '\n', '\n', '    contract ERC20Protocol {\n', '        /* This is a slight change to the ERC20 base standard.\n', '        function totalSupply() constant returns (uint supply);\n', '        is replaced with:\n', '        uint public totalSupply;\n', '        This automatically creates a getter function for the totalSupply.\n', '        This is moved to the base contract since public getter functions are not\n', '        currently recognised as an implementation of the matching abstract\n', '        function by the compiler.\n', '        */\n', '        /// total amount of tokens\n', '        uint public totalSupply;\n', '\n', '        /// @param _owner The address from which the balance will be retrieved\n', '        /// @return The balance\n', '        function balanceOf(address _owner) constant public returns (uint balance);\n', '\n', '        /// @notice send `_value` token to `_to` from `msg.sender`\n', '        /// @param _to The address of the recipient\n', '        /// @param _value The amount of token to be transferred\n', '        /// @return Whether the transfer was successful or not\n', '        function transfer(address _to, uint _value) public returns (bool success);\n', '\n', '        /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '        /// @param _from The address of the sender\n', '        /// @param _to The address of the recipient\n', '        /// @param _value The amount of token to be transferred\n', '        /// @return Whether the transfer was successful or not\n', '        function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '\n', '        /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '        /// @param _spender The address of the account able to transfer the tokens\n', '        /// @param _value The amount of tokens to be approved for transfer\n', '        /// @return Whether the approval was successful or not\n', '        function approve(address _spender, uint _value) public returns (bool success);\n', '\n', '        /// @param _owner The address of the account owning tokens\n', '        /// @param _spender The address of the account able to transfer the tokens\n', '        /// @return Amount of remaining tokens allowed to spent\n', '        function allowance(address _owner, address _spender) constant public returns (uint remaining);\n', '\n', '        event Transfer(address indexed _from, address indexed _to, uint _value);\n', '        event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    }\n', '\n', '    contract StandardToken is ERC20Protocol {\n', '        using SafeMath for uint;\n', '\n', '        /**\n', '        * @dev Fix for the ERC20 short address attack.\n', '        */\n', '        modifier onlyPayloadSize(uint size) {\n', '            require(msg.data.length >= size + 4);\n', '            _;\n', '        }\n', '\n', '        function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '            //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '            //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '            //Replace the if with this one instead.\n', '            //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            if (balances[msg.sender] >= _value) {\n', '                balances[msg.sender] -= _value;\n', '                balances[_to] += _value;\n', '                Transfer(msg.sender, _to, _value);\n', '                return true;\n', '            } else { return false; }\n', '        }\n', '\n', '        function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool success) {\n', '            //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '            //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {\n', '                balances[_to] += _value;\n', '                balances[_from] -= _value;\n', '                allowed[_from][msg.sender] -= _value;\n', '                Transfer(_from, _to, _value);\n', '                return true;\n', '            } else { return false; }\n', '        }\n', '\n', '        function balanceOf(address _owner) constant public returns (uint balance) {\n', '            return balances[_owner];\n', '        }\n', '\n', '        function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {\n', '            // To change the approve amount you first have to reduce the addresses`\n', '            //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '            //  already 0 to mitigate the race condition described here:\n', '            //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '            assert((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '            allowed[msg.sender][_spender] = _value;\n', '            Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        }\n', '\n', '        function allowance(address _owner, address _spender) constant public returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '        }\n', '\n', '        mapping (address => uint) balances;\n', '        mapping (address => mapping (address => uint)) allowed;\n', '    }\n', '\n', '    contract SharesChainToken is StandardToken {\n', '        /// Constant token specific fields\n', '        string public constant name = "SharesChainToken";\n', '        string public constant symbol = "SCTK";\n', '        uint public constant decimals = 18;\n', '\n', '        /// SharesChain total tokens supply\n', '        uint public constant MAX_TOTAL_TOKEN_AMOUNT = 20000000000 ether;\n', '\n', '        /// Fields that are only changed in constructor\n', '        /// SharesChain contribution contract\n', '        address public minter;\n', '\n', '        /*\n', '        * MODIFIERS\n', '        */\n', '\n', '        modifier onlyMinter {\n', '            assert(msg.sender == minter);\n', '            _;\n', '        }\n', '\n', '        modifier maxTokenAmountNotReached (uint amount){\n', '            assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);\n', '            _;\n', '        }\n', '\n', '        /**\n', '        * CONSTRUCTOR\n', '        *\n', '        * @dev Initialize the SharesChain Token\n', '        * @param _minter The SharesChain Crowd Funding Contract\n', '        */\n', '        function SharesChainToken(address _minter) public {\n', '            minter = _minter;\n', '        }\n', '\n', '\n', '        /**\n', '        * EXTERNAL FUNCTION\n', '        *\n', '        * @dev Contribution contract instance mint token\n', '        * @param recipient The destination account owned mint tokens\n', '        * be sent to this address.\n', '        */\n', '        function mintToken(address recipient, uint _amount)\n', '            public\n', '            onlyMinter\n', '            maxTokenAmountNotReached(_amount)\n', '            returns (bool)\n', '        {\n', '            totalSupply = totalSupply.add(_amount);\n', '            balances[recipient] = balances[recipient].add(_amount);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    contract SharesChainTokenCrowdFunding is Owned {\n', '    using SafeMath for uint;\n', '\n', '     /*\n', '      * Constant fields\n', '      */\n', '    /// SharesChain total tokens supply\n', '    uint public constant MAX_TOTAL_TOKEN_AMOUNT = 20000000000 ether;\n', '\n', '    // 最大募集以太币数量\n', '    uint public constant MAX_CROWD_FUNDING_ETH = 30000 ether;\n', '\n', '    // Reserved tokens\n', '    uint public constant TEAM_INCENTIVES_AMOUNT = 2000000000 ether; // 10%\n', '    uint public constant OPERATION_AMOUNT = 2000000000 ether;       // 10%\n', '    uint public constant MINING_POOL_AMOUNT = 8000000000 ether;     // 40%\n', '    uint public constant MAX_PRE_SALE_AMOUNT = 8000000000 ether;    // 40%\n', '\n', '    // Addresses of Patrons\n', '    address public TEAM_HOLDER;\n', '    address public MINING_POOL_HOLDER;\n', '    address public OPERATION_HOLDER;\n', '\n', '    /// Exchange rate 1 ether == 205128 SCTK\n', '    uint public constant EXCHANGE_RATE = 205128;\n', '    uint8 public constant MAX_UN_LOCK_TIMES = 10;\n', '\n', '    /// Fields that are only changed in constructor\n', '    /// All deposited ETH will be instantly forwarded to this address.\n', '    address public walletOwnerAddress;\n', '    /// Crowd sale start time\n', '    uint public startTime;\n', '\n', '\n', '    SharesChainToken public sharesChainToken;\n', '\n', '    /// Fields that can be changed by functions\n', '    uint16 public numFunders;\n', '    uint public preSoldTokens;\n', '    uint public crowdEther;\n', '\n', '    /// tags show address can join in open sale\n', '    mapping (address => bool) public whiteList;\n', '\n', '    /// 记录投资人地址\n', '    address[] private investors;\n', '\n', '    /// 记录剩余释放次数\n', '    mapping (address => uint8) leftReleaseTimes;\n', '\n', '    /// 记录投资人锁定的Token数量\n', '    mapping (address => uint) lockedTokens;\n', '\n', '    /// Due to an emergency, set this to true to halt the contribution\n', '    bool public halted;\n', '\n', '    /// 记录当前众筹是否结束\n', '    bool public close;\n', '\n', '    /*\n', '     * EVENTS\n', '     */\n', '\n', '    event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);\n', '\n', '    /*\n', '     * MODIFIERS\n', '     */\n', '    modifier notHalted() {\n', '        require(!halted);\n', '        _;\n', '    }\n', '\n', '    modifier isHalted() {\n', '        require(halted);\n', '        _;\n', '    }\n', '\n', '    modifier isOpen() {\n', '        require(!close);\n', '        _;\n', '    }\n', '\n', '    modifier isClose() {\n', '        require(close);\n', '        _;\n', '    }\n', '\n', '    modifier onlyWalletOwner {\n', '        require(msg.sender == walletOwnerAddress);\n', '        _;\n', '    }\n', '\n', '    modifier initialized() {\n', '        require(address(walletOwnerAddress) != 0x0);\n', '        _;\n', '    }\n', '\n', '    modifier ceilingEtherNotReached(uint x) {\n', '        require(crowdEther.add(x) <= MAX_CROWD_FUNDING_ETH);\n', '        _;\n', '    }\n', '\n', '    modifier earlierThan(uint x) {\n', '        require(now < x);\n', '        _;\n', '    }\n', '\n', '    modifier notEarlierThan(uint x) {\n', '        require(now >= x);\n', '        _;\n', '    }\n', '\n', '    modifier inWhiteList(address user) {\n', '        require(whiteList[user]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * CONSTRUCTOR\n', '     *\n', '     * @dev Initialize the SharesChainToken contribution contract\n', '     * @param _walletOwnerAddress The escrow account address, all ethers will be sent to this address.\n', '     * @param _startTime ICO boot time\n', '     */\n', '    function SharesChainTokenCrowdFunding(address _owner, address _walletOwnerAddress, uint _startTime, address _teamHolder, address _miningPoolHolder, address _operationHolder) public {\n', '        require(_walletOwnerAddress != 0x0);\n', '        owner = _owner;\n', '        halted = false;\n', '        close = false;\n', '        walletOwnerAddress = _walletOwnerAddress;\n', '        startTime = _startTime;\n', '        preSoldTokens = 0;\n', '        crowdEther = 0;\n', '        TEAM_HOLDER = _teamHolder;\n', '        MINING_POOL_HOLDER = _miningPoolHolder;\n', '        OPERATION_HOLDER = _operationHolder;\n', '        sharesChainToken = new SharesChainToken(this);\n', '        sharesChainToken.mintToken(_teamHolder, TEAM_INCENTIVES_AMOUNT);\n', '        sharesChainToken.mintToken(_miningPoolHolder, MINING_POOL_AMOUNT);\n', '        sharesChainToken.mintToken(_operationHolder, OPERATION_AMOUNT);\n', '    }\n', '\n', '    /**\n', '     * Fallback function\n', '     *\n', '     * @dev If anybody sends Ether directly to this  contract, consider he is getting SharesChain token\n', '     */\n', '    function () public payable {\n', '        buySCTK(msg.sender, msg.value);\n', '    }\n', '\n', '\n', '    /// @dev Exchange msg.value ether to SCTK for account receiver\n', '    /// @param receiver SCTK tokens receiver\n', '    function buySCTK(address receiver, uint costEth)\n', '        private\n', '        notHalted\n', '        isOpen\n', '        initialized\n', '        inWhiteList(receiver)\n', '        ceilingEtherNotReached(costEth)\n', '        notEarlierThan(startTime)\n', '        returns (bool)\n', '    {\n', '        require(receiver != 0x0);\n', '        require(costEth >= 1 ether);\n', '\n', '        // Do not allow contracts to game the system\n', '        require(!isContract(receiver));\n', '\n', '        if (lockedTokens[receiver] == 0) {\n', '            numFunders++;\n', '            investors.push(receiver);\n', '            leftReleaseTimes[receiver] = MAX_UN_LOCK_TIMES; // 禁止在执行解锁之后重新启动众筹\n', '        }\n', '\n', '        // 根据投资者输入的以太坊数量确定赠送的SCTK数量\n', '        uint gotTokens = calculateGotTokens(costEth);\n', '\n', '        // 累计预售的Token不能超过最大预售量\n', '        require(preSoldTokens.add(gotTokens) <= MAX_PRE_SALE_AMOUNT);\n', '        lockedTokens[receiver] = lockedTokens[receiver].add(gotTokens);\n', '        preSoldTokens = preSoldTokens.add(gotTokens);\n', '        crowdEther = crowdEther.add(costEth);\n', '        walletOwnerAddress.transfer(costEth);\n', '        NewSale(receiver, costEth, gotTokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @dev Set white list in batch.\n', '    function setWhiteListInBatch(address[] users)\n', '        public\n', '        onlyOwner\n', '    {\n', '        for (uint i = 0; i < users.length; i++) {\n', '            whiteList[users[i]] = true;\n', '        }\n', '    }\n', '\n', '    /// @dev  Add one user into white list.\n', '    function addOneUserIntoWhiteList(address user)\n', '        public\n', '        onlyOwner\n', '    {\n', '        whiteList[user] = true;\n', '    }\n', '\n', '    /// query locked tokens\n', '    function queryLockedTokens(address user) public view returns(uint) {\n', '        return lockedTokens[user];\n', '    }\n', '\n', '\n', '    // 根据投资者输入的以太坊数量确定赠送的SCTK数量\n', '    function calculateGotTokens(uint costEther) pure internal returns (uint gotTokens) {\n', '        gotTokens = costEther * EXCHANGE_RATE;\n', '        if (costEther > 0 && costEther < 100 ether) {\n', '            gotTokens = gotTokens.mul(1);\n', '        }else if (costEther >= 100 ether && costEther < 500 ether) {\n', '            gotTokens = gotTokens.mul(115).div(100);\n', '        }else {\n', '            gotTokens = gotTokens.mul(130).div(100);\n', '        }\n', '        return gotTokens;\n', '    }\n', '\n', '    /// @dev Emergency situation that requires contribution period to stop.\n', '    /// Contributing not possible anymore.\n', '    function halt() public onlyOwner {\n', '        halted = true;\n', '    }\n', '\n', '    /// @dev Emergency situation resolved.\n', '    /// Contributing becomes possible again withing the outlined restrictions.\n', '    function unHalt() public onlyOwner {\n', '        halted = false;\n', '    }\n', '\n', '    /// Stop crowding, cannot re-start.\n', '    function stopCrowding() public onlyOwner {\n', '        close = true;\n', '    }\n', '\n', '    /// @dev Emergency situation\n', '    function changeWalletOwnerAddress(address newWalletAddress) public onlyWalletOwner {\n', '        walletOwnerAddress = newWalletAddress;\n', '    }\n', '\n', '\n', '    /// @dev Internal function to determine if an address is a contract\n', '    /// @param _addr The address being queried\n', '    /// @return True if `_addr` is a contract\n', '    function isContract(address _addr) constant internal returns(bool) {\n', '        uint size;\n', '        if (_addr == 0) {\n', '            return false;\n', '        }\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '\n', '    function releaseRestPreSaleTokens()\n', '        public\n', '        onlyOwner\n', '        isClose\n', '    {\n', '        uint unSoldTokens = MAX_PRE_SALE_AMOUNT - preSoldTokens;\n', '        sharesChainToken.mintToken(OPERATION_HOLDER, unSoldTokens);\n', '    }\n', '\n', '    /*\n', '     * PUBLIC FUNCTIONS\n', '     */\n', '\n', '    /// Manually unlock 10% total tokens\n', '    function unlock10PercentTokensInBatch()\n', '        public\n', '        onlyOwner\n', '        isClose\n', '        returns (bool)\n', '    {\n', '        for (uint8 i = 0; i < investors.length; i++) {\n', '            if (leftReleaseTimes[investors[i]] > 0) {\n', '                uint releasedTokens = lockedTokens[investors[i]] / leftReleaseTimes[investors[i]];\n', '                sharesChainToken.mintToken(investors[i], releasedTokens);\n', '                lockedTokens[investors[i]] = lockedTokens[investors[i]] - releasedTokens;\n', '                leftReleaseTimes[investors[i]] = leftReleaseTimes[investors[i]] - 1;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '}']