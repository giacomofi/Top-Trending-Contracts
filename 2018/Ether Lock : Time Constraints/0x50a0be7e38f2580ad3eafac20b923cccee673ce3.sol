['pragma solidity ^0.4.24;\n', '\n', 'contract EthCalendar {\n', '    // Initial price of a day is 0.003 ETH\n', '    uint256 constant initialDayPrice = 3000000000000000 wei;\n', '\n', '    // Address of the contract owner\n', '    address contractOwner;\n', '\n', '    // Mapping of addresses to the pending withdrawal amount\n', '    mapping(address => uint256) pendingWithdrawals;\n', '\n', '    // Mapping of day ids to their structs\n', '    mapping(uint16 => Day) dayStructs;\n', '\n', '    // Fired when a day was bought\n', '    event DayBought(uint16 dayId);\n', '\n', '    // Holds all information about a day\n', '    struct Day {\n', '        address owner;\n', '        string message;\n', '        uint256 sellprice;\n', '        uint256 buyprice;\n', '    }\n', '\n', '    // Set contract owner on deploy\n', '    constructor() public {\n', '        contractOwner = msg.sender;\n', '    }\n', '\n', '    // Ensures sender is the contract owner\n', '    modifier onlyContractOwner() {\n', '        require(msg.sender == contractOwner, "sender must be contract owner");\n', '        _;\n', '    }\n', '\n', '    // Ensures dayid is in valid range\n', '    modifier onlyValidDay (uint16 dayId) {\n', '        require(dayId >= 0 && dayId <= 365, "day id must be between 0 and 365");\n', '        _;\n', '    }\n', '\n', '    // Ensures sender is the owner of a specific day\n', '    modifier onlyDayOwner(uint16 dayId) {\n', '        require(msg.sender == dayStructs[dayId].owner, "sender must be owner of day");\n', '        _;\n', '    }\n', '\n', '    // Ensures sender is not the owner of a specific day\n', '    modifier notDayOwner(uint16 dayId) {\n', '        require(msg.sender != dayStructs[dayId].owner, "sender can&#39;t be owner of day");\n', '        _;\n', '    }\n', '\n', '    // Ensures message is of a valid length\n', '    modifier onlyValidMessage(string message) {\n', '        require(bytes(message).length > 0, "message has to be set");\n', '        _;\n', '    }\n', '\n', '    // Ensures the updated sellprice is below the here defined moving maximum.\n', '    // The maximum is oriented to the price the day is bought.\n', '    // Into baseprice the buyprice needs to be passed. This could be either msg.value or a stored value from previous tx.\n', '    modifier onlyValidSellprice(uint256 sellprice, uint256 baseprice) {\n', '        // Set the moving maximum to twice the paid amount\n', '        require(sellprice > 0 && sellprice <= baseprice * 2, "new sell price must be lower than or equal to twice the paid price");\n', '        _;\n', '    }\n', '\n', '    // Ensures the transfered value of the tx is large enough to pay for a specific day\n', '    modifier onlySufficientPayment(uint16 dayId) {\n', '        // The current price needs to be covered by the sent amount.\n', '        // It is possible to pay more than needed.\n', '        require(msg.value >= getCurrentPrice(dayId), "tx value must be greater than or equal to price of day");\n', '        _;\n', '    }\n', '\n', '    // Any address can buy a day for the specified minimum price.\n', '    // A sell price and a message need to be specified in this call.\n', '    // The new sell price has a maximum of twice the paid amount.\n', '    // A day can be bought for more than the specified sell price. So the maximum new sell price can be arbitrary high.\n', '    function buyDay(uint16 dayId, uint256 sellprice, string message) public payable\n', '        onlyValidDay(dayId)\n', '        notDayOwner(dayId)\n', '        onlyValidMessage(message)\n', '        onlySufficientPayment(dayId)\n', '        onlyValidSellprice(sellprice, msg.value) {\n', '\n', '        if (hasOwner(dayId)) {\n', '            // Day already has an owner\n', '            // Contract owner takes 2% cut on transaction\n', '            uint256 contractOwnerCut = (msg.value * 200) / 10000;\n', '            uint256 dayOwnerShare = msg.value - contractOwnerCut;\n', '\n', '            // Credit contract owner and day owner their shares\n', '            pendingWithdrawals[contractOwner] += contractOwnerCut;\n', '            pendingWithdrawals[dayStructs[dayId].owner] += dayOwnerShare;\n', '        } else {\n', '            // Day has no owner yet.\n', '            // Contract owner gets credited the initial transaction\n', '            pendingWithdrawals[contractOwner] += msg.value;\n', '        }\n', '\n', '        // Update the data of the day bought\n', '        dayStructs[dayId].owner = msg.sender;\n', '        dayStructs[dayId].message = message;\n', '        dayStructs[dayId].sellprice = sellprice;\n', '        dayStructs[dayId].buyprice = msg.value;\n', '\n', '        emit DayBought(dayId);\n', '    }\n', '\n', '    // Owner can change price of his days\n', '    function changePrice(uint16 dayId, uint256 sellprice) public\n', '        onlyValidDay(dayId)\n', '        onlyDayOwner(dayId)\n', '        onlyValidSellprice(sellprice, dayStructs[dayId].buyprice) {\n', '        dayStructs[dayId].sellprice = sellprice;\n', '    }\n', '\n', '    // Owner can change personal message of his days\n', '    function changeMessage(uint16 dayId, string message) public\n', '        onlyValidDay(dayId)\n', '        onlyDayOwner(dayId)\n', '        onlyValidMessage(message) {\n', '        dayStructs[dayId].message = message;\n', '    }\n', '\n', '    // Owner can tranfer his day to another address\n', '    function transferDay(uint16 dayId, address recipient) public\n', '        onlyValidDay(dayId)\n', '        onlyDayOwner(dayId) {\n', '        dayStructs[dayId].owner = recipient;\n', '    }\n', '\n', '    // Returns day details\n', '    function getDay (uint16 dayId) public view\n', '        onlyValidDay(dayId)\n', '    returns (uint16 id, address owner, string message, uint256 sellprice, uint256 buyprice) {\n', '        return(  \n', '            dayId,\n', '            dayStructs[dayId].owner,\n', '            dayStructs[dayId].message,\n', '            getCurrentPrice(dayId),\n', '            dayStructs[dayId].buyprice\n', '        );    \n', '    }\n', '\n', '    // Returns the senders balance\n', '    function getBalance() public view\n', '    returns (uint256 amount) {\n', '        return pendingWithdrawals[msg.sender];\n', '    }\n', '\n', '    // User can withdraw his balance\n', '    function withdraw() public {\n', '        uint256 amount = pendingWithdrawals[msg.sender];\n', '        pendingWithdrawals[msg.sender] = 0;\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '    // Returns whether or not the day is already bought\n', '    function hasOwner(uint16 dayId) private view\n', '    returns (bool dayHasOwner) {\n', '        return dayStructs[dayId].owner != address(0);\n', '    }\n', '\n', '    // Returns the price the day currently can be bought for\n', '    function getCurrentPrice(uint16 dayId) private view\n', '    returns (uint256 currentPrice) {\n', '        return hasOwner(dayId) ?\n', '            dayStructs[dayId].sellprice :\n', '            initialDayPrice;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract EthCalendar {\n', '    // Initial price of a day is 0.003 ETH\n', '    uint256 constant initialDayPrice = 3000000000000000 wei;\n', '\n', '    // Address of the contract owner\n', '    address contractOwner;\n', '\n', '    // Mapping of addresses to the pending withdrawal amount\n', '    mapping(address => uint256) pendingWithdrawals;\n', '\n', '    // Mapping of day ids to their structs\n', '    mapping(uint16 => Day) dayStructs;\n', '\n', '    // Fired when a day was bought\n', '    event DayBought(uint16 dayId);\n', '\n', '    // Holds all information about a day\n', '    struct Day {\n', '        address owner;\n', '        string message;\n', '        uint256 sellprice;\n', '        uint256 buyprice;\n', '    }\n', '\n', '    // Set contract owner on deploy\n', '    constructor() public {\n', '        contractOwner = msg.sender;\n', '    }\n', '\n', '    // Ensures sender is the contract owner\n', '    modifier onlyContractOwner() {\n', '        require(msg.sender == contractOwner, "sender must be contract owner");\n', '        _;\n', '    }\n', '\n', '    // Ensures dayid is in valid range\n', '    modifier onlyValidDay (uint16 dayId) {\n', '        require(dayId >= 0 && dayId <= 365, "day id must be between 0 and 365");\n', '        _;\n', '    }\n', '\n', '    // Ensures sender is the owner of a specific day\n', '    modifier onlyDayOwner(uint16 dayId) {\n', '        require(msg.sender == dayStructs[dayId].owner, "sender must be owner of day");\n', '        _;\n', '    }\n', '\n', '    // Ensures sender is not the owner of a specific day\n', '    modifier notDayOwner(uint16 dayId) {\n', '        require(msg.sender != dayStructs[dayId].owner, "sender can\'t be owner of day");\n', '        _;\n', '    }\n', '\n', '    // Ensures message is of a valid length\n', '    modifier onlyValidMessage(string message) {\n', '        require(bytes(message).length > 0, "message has to be set");\n', '        _;\n', '    }\n', '\n', '    // Ensures the updated sellprice is below the here defined moving maximum.\n', '    // The maximum is oriented to the price the day is bought.\n', '    // Into baseprice the buyprice needs to be passed. This could be either msg.value or a stored value from previous tx.\n', '    modifier onlyValidSellprice(uint256 sellprice, uint256 baseprice) {\n', '        // Set the moving maximum to twice the paid amount\n', '        require(sellprice > 0 && sellprice <= baseprice * 2, "new sell price must be lower than or equal to twice the paid price");\n', '        _;\n', '    }\n', '\n', '    // Ensures the transfered value of the tx is large enough to pay for a specific day\n', '    modifier onlySufficientPayment(uint16 dayId) {\n', '        // The current price needs to be covered by the sent amount.\n', '        // It is possible to pay more than needed.\n', '        require(msg.value >= getCurrentPrice(dayId), "tx value must be greater than or equal to price of day");\n', '        _;\n', '    }\n', '\n', '    // Any address can buy a day for the specified minimum price.\n', '    // A sell price and a message need to be specified in this call.\n', '    // The new sell price has a maximum of twice the paid amount.\n', '    // A day can be bought for more than the specified sell price. So the maximum new sell price can be arbitrary high.\n', '    function buyDay(uint16 dayId, uint256 sellprice, string message) public payable\n', '        onlyValidDay(dayId)\n', '        notDayOwner(dayId)\n', '        onlyValidMessage(message)\n', '        onlySufficientPayment(dayId)\n', '        onlyValidSellprice(sellprice, msg.value) {\n', '\n', '        if (hasOwner(dayId)) {\n', '            // Day already has an owner\n', '            // Contract owner takes 2% cut on transaction\n', '            uint256 contractOwnerCut = (msg.value * 200) / 10000;\n', '            uint256 dayOwnerShare = msg.value - contractOwnerCut;\n', '\n', '            // Credit contract owner and day owner their shares\n', '            pendingWithdrawals[contractOwner] += contractOwnerCut;\n', '            pendingWithdrawals[dayStructs[dayId].owner] += dayOwnerShare;\n', '        } else {\n', '            // Day has no owner yet.\n', '            // Contract owner gets credited the initial transaction\n', '            pendingWithdrawals[contractOwner] += msg.value;\n', '        }\n', '\n', '        // Update the data of the day bought\n', '        dayStructs[dayId].owner = msg.sender;\n', '        dayStructs[dayId].message = message;\n', '        dayStructs[dayId].sellprice = sellprice;\n', '        dayStructs[dayId].buyprice = msg.value;\n', '\n', '        emit DayBought(dayId);\n', '    }\n', '\n', '    // Owner can change price of his days\n', '    function changePrice(uint16 dayId, uint256 sellprice) public\n', '        onlyValidDay(dayId)\n', '        onlyDayOwner(dayId)\n', '        onlyValidSellprice(sellprice, dayStructs[dayId].buyprice) {\n', '        dayStructs[dayId].sellprice = sellprice;\n', '    }\n', '\n', '    // Owner can change personal message of his days\n', '    function changeMessage(uint16 dayId, string message) public\n', '        onlyValidDay(dayId)\n', '        onlyDayOwner(dayId)\n', '        onlyValidMessage(message) {\n', '        dayStructs[dayId].message = message;\n', '    }\n', '\n', '    // Owner can tranfer his day to another address\n', '    function transferDay(uint16 dayId, address recipient) public\n', '        onlyValidDay(dayId)\n', '        onlyDayOwner(dayId) {\n', '        dayStructs[dayId].owner = recipient;\n', '    }\n', '\n', '    // Returns day details\n', '    function getDay (uint16 dayId) public view\n', '        onlyValidDay(dayId)\n', '    returns (uint16 id, address owner, string message, uint256 sellprice, uint256 buyprice) {\n', '        return(  \n', '            dayId,\n', '            dayStructs[dayId].owner,\n', '            dayStructs[dayId].message,\n', '            getCurrentPrice(dayId),\n', '            dayStructs[dayId].buyprice\n', '        );    \n', '    }\n', '\n', '    // Returns the senders balance\n', '    function getBalance() public view\n', '    returns (uint256 amount) {\n', '        return pendingWithdrawals[msg.sender];\n', '    }\n', '\n', '    // User can withdraw his balance\n', '    function withdraw() public {\n', '        uint256 amount = pendingWithdrawals[msg.sender];\n', '        pendingWithdrawals[msg.sender] = 0;\n', '        msg.sender.transfer(amount);\n', '    }\n', '\n', '    // Returns whether or not the day is already bought\n', '    function hasOwner(uint16 dayId) private view\n', '    returns (bool dayHasOwner) {\n', '        return dayStructs[dayId].owner != address(0);\n', '    }\n', '\n', '    // Returns the price the day currently can be bought for\n', '    function getCurrentPrice(uint16 dayId) private view\n', '    returns (uint256 currentPrice) {\n', '        return hasOwner(dayId) ?\n', '            dayStructs[dayId].sellprice :\n', '            initialDayPrice;\n', '    }\n', '}']
