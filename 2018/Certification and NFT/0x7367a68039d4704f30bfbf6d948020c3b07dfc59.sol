['pragma solidity ^0.4.19;\n', '\n', '\n', '/**\n', ' * A contract containing the fundamental state variables of the Beercoin\n', ' */\n', 'contract InternalBeercoin {\n', '    // As 18 decimal places will be used, the constants are multiplied by 10^18\n', '    uint256 internal constant INITIAL_SUPPLY = 15496000000 * 10**18;\n', '    uint256 internal constant DIAMOND_VALUE = 10000 * 10**18;\n', '    uint256 internal constant GOLD_VALUE = 100 * 10**18;\n', '    uint256 internal constant SILVER_VALUE = 10 * 10**18;\n', '    uint256 internal constant BRONZE_VALUE = 1 * 10**18;\n', '\n', '    // In addition to the initial total supply of 15496000000 Beercoins,\n', '    // more Beercoins will only be added by scanning bottle caps.\n', '    // 20800000000 bottle caps will be eventually produced.\n', '    //\n', '    // Within 10000 bottle caps,\n', '    // 1 (i.e. every 10000th cap in total) has a value of 10000 ("Diamond") Beercoins,\n', '    // 9 (i.e. every 1000th cap in total) have a value of 100 ("Gold") Beercoins,\n', '    // 990 (i.e. every 10th cap in total) have a value of 10 ("Silver") Beercoins,\n', '    // 9000 (i.e. every remaining cap) have a value of 1 ("Bronze") Beercoin.\n', '    //\n', '    // Therefore one bottle cap has an average Beercoin value of\n', '    // (1 * 10000 + 9 * 100 + 990 * 10 + 9000 * 1) / 10000 = 2.98.\n', '    //\n', '    // This means the total Beercoin value of all bottle caps that will\n', '    // be eventually produced equals 20800000000 * 2.98 = 61984000000.\n', '    uint64 internal producibleCaps = 20800000000;\n', '\n', '    // The  amounts of diamond, gold, silver, and bronze caps are stored\n', '    // as a single 256-bit value divided into four sections of 64 bits.\n', '    //\n', '    // Bits 255 to 192 are used for the amount of diamond caps,\n', '    // bits 191 to 128 are used for the amount of gold caps,\n', '    // bits 127 to 64 are used for the amount of silver caps,\n', '    // bits 63 to 0 are used for the amount of bronze caps.\n', '    //\n', '    // For example, the following numbers represent a single cap of a certain type:\n', '    // 0x0000000000000001000000000000000000000000000000000000000000000000 (diamond)\n', '    // 0x0000000000000000000000000000000100000000000000000000000000000000 (gold)\n', '    // 0x0000000000000000000000000000000000000000000000010000000000000000 (silver)\n', '    // 0x0000000000000000000000000000000000000000000000000000000000000001 (bronze)\n', '    uint256 internal packedProducedCaps = 0;\n', '    uint256 internal packedScannedCaps = 0;\n', '\n', '    // The amount of irreversibly burnt Beercoins\n', '    uint256 internal burntValue = 0;\n', '}\n', '\n', '\n', '/**\n', ' * A contract containing functions to understand the packed low-level data\n', ' */\n', 'contract ExplorableBeercoin is InternalBeercoin {\n', '    /**\n', '     * The amount of caps that can still be produced\n', '     */\n', '    function unproducedCaps() public view returns (uint64) {\n', '        return producibleCaps;\n', '    }\n', '\n', '    /**\n', '     * The amount of caps that is produced but not yet scanned\n', '     */\n', '    function unscannedCaps() public view returns (uint64) {\n', '        uint256 caps = packedProducedCaps - packedScannedCaps;\n', '        uint64 amount = uint64(caps >> 192);\n', '        amount += uint64(caps >> 128);\n', '        amount += uint64(caps >> 64);\n', '        amount += uint64(caps);\n', '        return amount;\n', '    }\n', '\n', '    /**\n', '     * The amount of all caps produced so far\n', '     */\n', '    function producedCaps() public view returns (uint64) {\n', '        uint256 caps = packedProducedCaps;\n', '        uint64 amount = uint64(caps >> 192);\n', '        amount += uint64(caps >> 128);\n', '        amount += uint64(caps >> 64);\n', '        amount += uint64(caps);\n', '        return amount;\n', '    }\n', '\n', '    /**\n', '     * The amount of all caps scanned so far\n', '     */\n', '    function scannedCaps() public view returns (uint64) {\n', '        uint256 caps = packedScannedCaps;\n', '        uint64 amount = uint64(caps >> 192);\n', '        amount += uint64(caps >> 128);\n', '        amount += uint64(caps >> 64);\n', '        amount += uint64(caps);\n', '        return amount;\n', '    }\n', '\n', '    /**\n', '     * The amount of diamond caps produced so far\n', '     */\n', '    function producedDiamondCaps() public view returns (uint64) {\n', '        return uint64(packedProducedCaps >> 192);\n', '    }\n', '\n', '    /**\n', '     * The amount of diamond caps scanned so far\n', '     */\n', '    function scannedDiamondCaps() public view returns (uint64) {\n', '        return uint64(packedScannedCaps >> 192);\n', '    }\n', '\n', '    /**\n', '     * The amount of gold caps produced so far\n', '     */\n', '    function producedGoldCaps() public view returns (uint64) {\n', '        return uint64(packedProducedCaps >> 128);\n', '    }\n', '\n', '    /**\n', '     * The amount of gold caps scanned so far\n', '     */\n', '    function scannedGoldCaps() public view returns (uint64) {\n', '        return uint64(packedScannedCaps >> 128);\n', '    }\n', '\n', '    /**\n', '     * The amount of silver caps produced so far\n', '     */\n', '    function producedSilverCaps() public view returns (uint64) {\n', '        return uint64(packedProducedCaps >> 64);\n', '    }\n', '\n', '    /**\n', '     * The amount of silver caps scanned so far\n', '     */\n', '    function scannedSilverCaps() public view returns (uint64) {\n', '        return uint64(packedScannedCaps >> 64);\n', '    }\n', '\n', '    /**\n', '     * The amount of bronze caps produced so far\n', '     */\n', '    function producedBronzeCaps() public view returns (uint64) {\n', '        return uint64(packedProducedCaps);\n', '    }\n', '\n', '    /**\n', '     * The amount of bronze caps scanned so far\n', '     */\n', '    function scannedBronzeCaps() public view returns (uint64) {\n', '        return uint64(packedScannedCaps);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * A contract implementing all standard ERC20 functionality for the Beercoin\n', ' */\n', 'contract ERC20Beercoin is ExplorableBeercoin {\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowances;\n', '\n', '    /**\n', "     * Beercoin's name\n", '     */\n', '    function name() public pure returns (string) {\n', '        return "Beercoin";\n', '    }\n', '\n', '    /**\n', "     * Beercoin's symbol\n", '     */\n', '    function symbol() public pure returns (string) {\n', '        return "?";\n', '    }\n', '\n', '    /**\n', "     * Beercoin's decimal places\n", '     */\n', '    function decimals() public pure returns (uint8) {\n', '        return 18;\n', '    }\n', '\n', '    /**\n', '     * The current total supply of Beercoins\n', '     */\n', '    function totalSupply() public view returns (uint256) {\n', '        uint256 caps = packedScannedCaps;\n', '        uint256 supply = INITIAL_SUPPLY;\n', '        supply += (caps >> 192) * DIAMOND_VALUE;\n', '        supply += ((caps >> 128) & 0xFFFFFFFFFFFFFFFF) * GOLD_VALUE;\n', '        supply += ((caps >> 64) & 0xFFFFFFFFFFFFFFFF) * SILVER_VALUE;\n', '        supply += (caps & 0xFFFFFFFFFFFFFFFF) * BRONZE_VALUE;\n', '        return supply - burntValue;\n', '    }\n', '\n', '    /**\n', '     * Check the balance of a Beercoin user\n', '     *\n', '     * @param _owner the user to check\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '     * Transfer Beercoins to another user\n', '     *\n', '     * @param _to the address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != 0x0);\n', '\n', '        uint256 balanceFrom = balances[msg.sender];\n', '\n', '        require(_value <= balanceFrom);\n', '\n', '        uint256 oldBalanceTo = balances[_to];\n', '        uint256 newBalanceTo = oldBalanceTo + _value;\n', '\n', '        require(oldBalanceTo <= newBalanceTo);\n', '\n', '        balances[msg.sender] = balanceFrom - _value;\n', '        balances[_to] = newBalanceTo;\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer Beercoins from other address if a respective allowance exists\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _to the address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != 0x0);\n', '\n', '        uint256 balanceFrom = balances[_from];\n', '        uint256 allowanceFrom = allowances[_from][msg.sender];\n', '\n', '        require(_value <= balanceFrom);\n', '        require(_value <= allowanceFrom);\n', '\n', '        uint256 oldBalanceTo = balances[_to];\n', '        uint256 newBalanceTo = oldBalanceTo + _value;\n', '\n', '        require(oldBalanceTo <= newBalanceTo);\n', '\n', '        balances[_from] = balanceFrom - _value;\n', '        balances[_to] = newBalanceTo;\n', '        allowances[_from][msg.sender] = allowanceFrom - _value;\n', '\n', '        Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allow another user to spend a certain amount of Beercoins on your behalf\n', '     *\n', '     * @param _spender the address of the user authorized to spend\n', '     * @param _value the maximum amount that can be spent on your behalf\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowances[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * The amount of Beercoins that can be spent by a user on behalf of another\n', '     *\n', '     * @param _owner the address of the user user whose Beercoins are spent\n', '     * @param _spender the address of the user who executes the transaction\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * A contract that defines a master with special debiting abilities\n', ' * required for operating a user-friendly Beercoin redemption system\n', ' */\n', 'contract MasteredBeercoin is ERC20Beercoin {\n', '    address internal beercoinMaster;\n', '    mapping (address => bool) internal directDebitAllowances;\n', '\n', '    /**\n', '     * Construct the MasteredBeercoin contract\n', '     * and make the sender the master\n', '     */\n', '    function MasteredBeercoin() public {\n', '        beercoinMaster = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Restrict to the master only\n', '     */\n', '    modifier onlyMaster {\n', '        require(msg.sender == beercoinMaster);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * The master of the Beercoin\n', '     */\n', '    function master() public view returns (address) {\n', '        return beercoinMaster;\n', '    }\n', '\n', '    /**\n', '     * Declare a master at another address\n', '     *\n', "     * @param newMaster the new owner's address\n", '     */\n', '    function declareNewMaster(address newMaster) public onlyMaster {\n', '        beercoinMaster = newMaster;\n', '    }\n', '\n', '    /**\n', '     * Allow the master to withdraw Beercoins from your\n', "     * account so you don't have to send Beercoins yourself\n", '     */\n', '    function allowDirectDebit() public {\n', '        directDebitAllowances[msg.sender] = true;\n', '    }\n', '\n', '    /**\n', '     * Forbid the master to withdraw Beercoins from you account\n', '     */\n', '    function forbidDirectDebit() public {\n', '        directDebitAllowances[msg.sender] = false;\n', '    }\n', '\n', '    /**\n', '     * Check whether a user allows direct debits by the master\n', '     *\n', '     * @param user the user to check\n', '     */\n', '    function directDebitAllowance(address user) public view returns (bool) {\n', '        return directDebitAllowances[user];\n', '    }\n', '\n', '    /**\n', '     * Withdraw Beercoins from multiple users\n', '     *\n', '     * Beercoins are only withdrawn this way if and only if\n', '     * a user deliberately wants it to happen by initiating\n', '     * a transaction on a plattform operated by the owner\n', '     *\n', '     * @param users the addresses of the users to take Beercoins from\n', '     * @param values the respective amounts to take\n', '     */\n', '    function debit(address[] users, uint256[] values) public onlyMaster returns (bool) {\n', '        require(users.length == values.length);\n', '\n', '        uint256 oldBalance = balances[msg.sender];\n', '        uint256 newBalance = oldBalance;\n', '\n', '        address currentUser;\n', '        uint256 currentValue;\n', '        uint256 currentBalance;\n', '        for (uint256 i = 0; i < users.length; ++i) {\n', '            currentUser = users[i];\n', '            currentValue = values[i];\n', '            currentBalance = balances[currentUser];\n', '\n', '            require(directDebitAllowances[currentUser]);\n', '            require(currentValue <= currentBalance);\n', '            balances[currentUser] = currentBalance - currentValue;\n', '            \n', '            newBalance += currentValue;\n', '\n', '            Transfer(currentUser, msg.sender, currentValue);\n', '        }\n', '\n', '        require(oldBalance <= newBalance);\n', '        balances[msg.sender] = newBalance;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Withdraw Beercoins from multiple users\n', '     *\n', '     * Beercoins are only withdrawn this way if and only if\n', '     * a user deliberately wants it to happen by initiating\n', '     * a transaction on a plattform operated by the owner\n', '     *\n', '     * @param users the addresses of the users to take Beercoins from\n', '     * @param value the amount to take from each user\n', '     */\n', '    function debitEqually(address[] users, uint256 value) public onlyMaster returns (bool) {\n', '        uint256 oldBalance = balances[msg.sender];\n', '        uint256 newBalance = oldBalance + (users.length * value);\n', '\n', '        require(oldBalance <= newBalance);\n', '        balances[msg.sender] = newBalance;\n', '\n', '        address currentUser;\n', '        uint256 currentBalance;\n', '        for (uint256 i = 0; i < users.length; ++i) {\n', '            currentUser = users[i];\n', '            currentBalance = balances[currentUser];\n', '\n', '            require(directDebitAllowances[currentUser]);\n', '            require(value <= currentBalance);\n', '            balances[currentUser] = currentBalance - value;\n', '\n', '            Transfer(currentUser, msg.sender, value);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Send Beercoins to multiple users\n', '     *\n', '     * @param users the addresses of the users to send Beercoins to\n', '     * @param values the respective amounts to send\n', '     */\n', '    function credit(address[] users, uint256[] values) public onlyMaster returns (bool) {\n', '        require(users.length == values.length);\n', '\n', '        uint256 balance = balances[msg.sender];\n', '        uint256 totalValue = 0;\n', '\n', '        address currentUser;\n', '        uint256 currentValue;\n', '        uint256 currentOldBalance;\n', '        uint256 currentNewBalance;\n', '        for (uint256 i = 0; i < users.length; ++i) {\n', '            currentUser = users[i];\n', '            currentValue = values[i];\n', '            currentOldBalance = balances[currentUser];\n', '            currentNewBalance = currentOldBalance + currentValue;\n', '\n', '            require(currentOldBalance <= currentNewBalance);\n', '            balances[currentUser] = currentNewBalance;\n', '\n', '            totalValue += currentValue;\n', '\n', '            Transfer(msg.sender, currentUser, currentValue);\n', '        }\n', '\n', '        require(totalValue <= balance);\n', '        balances[msg.sender] = balance - totalValue;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Send Beercoins to multiple users\n', '     *\n', '     * @param users the addresses of the users to send Beercoins to\n', '     * @param value the amounts to send to each user\n', '     */\n', '    function creditEqually(address[] users, uint256 value) public onlyMaster returns (bool) {\n', '        uint256 balance = balances[msg.sender];\n', '        uint256 totalValue = users.length * value;\n', '\n', '        require(totalValue <= balance);\n', '        balances[msg.sender] = balance - totalValue;\n', '\n', '        address currentUser;\n', '        uint256 currentOldBalance;\n', '        uint256 currentNewBalance;\n', '        for (uint256 i = 0; i < users.length; ++i) {\n', '            currentUser = users[i];\n', '            currentOldBalance = balances[currentUser];\n', '            currentNewBalance = currentOldBalance + value;\n', '\n', '            require(currentOldBalance <= currentNewBalance);\n', '            balances[currentUser] = currentNewBalance;\n', '\n', '            Transfer(msg.sender, currentUser, value);\n', '        }\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * A contract that defines the central business logic\n', ' * which also mirrors the life of a Beercoin\n', ' */\n', 'contract Beercoin is MasteredBeercoin {\n', '    event Produce(uint256 newCaps);\n', '    event Scan(address[] users, uint256[] caps);\n', '    event Burn(uint256 value);\n', '\n', '    /**\n', '     * Construct the Beercoin contract and\n', '     * assign the initial supply to the creator\n', '     */\n', '    function Beercoin() public {\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '    }\n', '\n', '    /**\n', '     * Increase the amounts of produced diamond, gold, silver, and\n', '     * bronze bottle caps in respect to their occurrence probabilities\n', '     *\n', '     * This function is called if and only if a brewery has actually\n', '     * ordered codes to produce the specified amount of bottle caps\n', '     *\n', '     * @param numberOfCaps the number of bottle caps to be produced\n', '     */\n', '    function produce(uint64 numberOfCaps) public onlyMaster returns (bool) {\n', '        require(numberOfCaps <= producibleCaps);\n', '\n', '        uint256 producedCaps = packedProducedCaps;\n', '\n', '        uint64 targetTotalCaps = numberOfCaps;\n', '        targetTotalCaps += uint64(producedCaps >> 192);\n', '        targetTotalCaps += uint64(producedCaps >> 128);\n', '        targetTotalCaps += uint64(producedCaps >> 64);\n', '        targetTotalCaps += uint64(producedCaps);\n', '\n', '        uint64 targetDiamondCaps = (targetTotalCaps - (targetTotalCaps % 10000)) / 10000;\n', '        uint64 targetGoldCaps = ((targetTotalCaps - (targetTotalCaps % 1000)) / 1000) - targetDiamondCaps;\n', '        uint64 targetSilverCaps = ((targetTotalCaps - (targetTotalCaps % 10)) / 10) - targetDiamondCaps - targetGoldCaps;\n', '        uint64 targetBronzeCaps = targetTotalCaps - targetDiamondCaps - targetGoldCaps - targetSilverCaps;\n', '\n', '        uint256 targetProducedCaps = 0;\n', '        targetProducedCaps |= uint256(targetDiamondCaps) << 192;\n', '        targetProducedCaps |= uint256(targetGoldCaps) << 128;\n', '        targetProducedCaps |= uint256(targetSilverCaps) << 64;\n', '        targetProducedCaps |= uint256(targetBronzeCaps);\n', '\n', '        producibleCaps -= numberOfCaps;\n', '        packedProducedCaps = targetProducedCaps;\n', '\n', '        Produce(targetProducedCaps - producedCaps);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Approve scans of multiple users and grant Beercoins\n', '     *\n', '     * This function is called periodically to mass-transfer Beercoins to\n', '     * multiple users if and only if each of them has scanned codes that\n', '     * our server has never verified before for the same or another user\n', '     *\n', '     * @param users the addresses of the users who scanned valid codes\n', '     * @param caps the amounts of caps the users have scanned as single 256-bit values\n', '     */\n', '    function scan(address[] users, uint256[] caps) public onlyMaster returns (bool) {\n', '        require(users.length == caps.length);\n', '\n', '        uint256 scannedCaps = packedScannedCaps;\n', '\n', '        uint256 currentCaps;\n', '        uint256 capsValue;\n', '        for (uint256 i = 0; i < users.length; ++i) {\n', '            currentCaps = caps[i];\n', '\n', '            capsValue = DIAMOND_VALUE * (currentCaps >> 192);\n', '            capsValue += GOLD_VALUE * ((currentCaps >> 128) & 0xFFFFFFFFFFFFFFFF);\n', '            capsValue += SILVER_VALUE * ((currentCaps >> 64) & 0xFFFFFFFFFFFFFFFF);\n', '            capsValue += BRONZE_VALUE * (currentCaps & 0xFFFFFFFFFFFFFFFF);\n', '\n', '            balances[users[i]] += capsValue;\n', '            scannedCaps += currentCaps;\n', '        }\n', '\n', '        require(scannedCaps <= packedProducedCaps);\n', '        packedScannedCaps = scannedCaps;\n', '\n', '        Scan(users, caps);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Remove Beercoins from the system irreversibly\n', '     *\n', '     * @param value the amount of Beercoins to burn\n', '     */\n', '    function burn(uint256 value) public onlyMaster returns (bool) {\n', '        uint256 balance = balances[msg.sender];\n', '        require(value <= balance);\n', '\n', '        balances[msg.sender] = balance - value;\n', '        burntValue += value;\n', '\n', '        Burn(value);\n', '\n', '        return true;\n', '    }\n', '}']