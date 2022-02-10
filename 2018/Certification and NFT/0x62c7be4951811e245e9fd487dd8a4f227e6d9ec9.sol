['/*\n', ' * Kryptium Tracker Smart Contract v.1.0.0\n', ' * Copyright © 2018 Kryptium Team <info@kryptium.io>\n', ' * Author: Giannis Zarifis <jzarifis@kryptium.io>\n', ' * \n', ' * A registry of betting houses based on the Ethereum blockchain. It keeps track\n', " * of users' upvotes/downvotes for specific houses and can be fully autonomous \n", ' * or managed.\n', ' *\n', ' * This program is free to use according the Terms of Use available at\n', ' * <https://kryptium.io/terms-of-use/>. You cannot resell it or copy any\n', ' * part of it or modify it without permission from the Kryptium Team.\n', ' *\n', ' * This program is distributed in the hope that it will be useful, but WITHOUT \n', ' * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS\n', ' * FOR A PARTICULAR PURPOSE. See the Terms and Conditions for more details.\n', ' */\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * SafeMath\n', ' * Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b != 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal pure returns (uint256) {\n', '        return div(mul(number, numerator), denominator);\n', '    }\n', '}\n', '\n', 'contract Owned {\n', '\n', '    address payable public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable newOwner) onlyOwner public {\n', '        require(newOwner != address(0x0));\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '/*\n', ' * House smart contract interface\n', ' */\n', 'interface HouseContract {\n', '     function owner() external view returns (address); \n', '     function isHouse() external view returns (bool);\n', '     function isPlayer(address playerAddress) external view returns(bool);\n', '}\n', '\n', '/*\n', ' * Kryptium Tracker Smart Contract.  \n', ' */\n', 'contract Tracker is SafeMath, Owned {\n', '\n', '\n', '\n', '\n', '    enum Action { added, updated}\n', '\n', '    struct House {            \n', '        uint upVotes;             \n', '        uint downVotes;\n', '        bool isActive;\n', '        address oldAddress;\n', '        address owner;\n', '    }\n', '\n', '    struct TrackerData { \n', '        string  name;\n', '        string  creatorName;\n', '        bool  managed;\n', '        uint trackerVersion;\n', '    }    \n', '\n', '\n', '    TrackerData public trackerData;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => House) public houses;\n', '\n', '    // Player has upvoted a House\n', '    mapping (address => mapping (address => bool)) public playerUpvoted;\n', '\n', '    // Player has downvoted a House\n', '    mapping (address => mapping (address => bool)) public playerDownvoted;\n', '\n', '    // Notifies clients that a house was inserted/altered\n', '    event TrackerChanged(address indexed  newHouseAddress, Action action);\n', '\n', '    // Notifies clients that a new tracker was launched\n', '    event TrackerCreated();\n', '\n', "    // Notifies clients that the Tracker's name was changed\n", '    event TrackerNamesUpdated();    \n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     * Initializes Tracker data\n', '     */\n', '    constructor(string memory trackerName, string memory trackerCreatorName, bool trackerIsManaged, uint version) public {\n', '        trackerData.name = trackerName;\n', '        trackerData.creatorName = trackerCreatorName;\n', '        trackerData.managed = trackerIsManaged;\n', '        trackerData.trackerVersion = version;\n', '        emit TrackerCreated();\n', '    }\n', '\n', '     /**\n', '     * Update Tracker Data function\n', '     *\n', '     * Updates trackersstats\n', '     */\n', '    function updateTrackerNames(string memory newName, string memory newCreatorName) onlyOwner public {\n', '        trackerData.name = newName;\n', '        trackerData.creatorName = newCreatorName;\n', '        emit TrackerNamesUpdated();\n', '    }    \n', '\n', '     /**\n', '     * Add House function\n', '     *\n', '     * Adds a new house\n', '     */\n', '    function addHouse(address houseAddress) public {\n', '        require(!trackerData.managed || msg.sender==owner,"Tracker is managed");\n', '        require(!houses[houseAddress].isActive,"There is a new version of House already registered");    \n', '        HouseContract houseContract = HouseContract(houseAddress);\n', '        require(houseContract.isHouse(),"Invalid House");\n', '        houses[houseAddress].isActive = true;\n', '        houses[houseAddress].owner = houseContract.owner();\n', '        emit TrackerChanged(houseAddress,Action.added);\n', '    }\n', '\n', '    /**\n', '     * Update House function\n', '     *\n', '     * Updates a house \n', '     */\n', '    function updateHouse(address newHouseAddress,address oldHouseAddress) public {\n', '        require(!trackerData.managed || msg.sender==owner,"Tracker is managed");\n', '        require(houses[oldHouseAddress].owner==msg.sender || houses[oldHouseAddress].owner==oldHouseAddress,"Caller isn\'t the owner of old House");\n', '        require(!houses[newHouseAddress].isActive,"There is a new version of House already registered");  \n', '        HouseContract houseContract = HouseContract(newHouseAddress);\n', '        require(houseContract.isHouse(),"Invalid House");\n', '        houses[oldHouseAddress].isActive = false;\n', '        houses[newHouseAddress].isActive = true;\n', '        houses[newHouseAddress].owner = houseContract.owner();\n', '        houses[newHouseAddress].upVotes = houses[oldHouseAddress].upVotes;\n', '        houses[newHouseAddress].downVotes = houses[oldHouseAddress].downVotes;\n', '        houses[newHouseAddress].oldAddress = oldHouseAddress;\n', '        emit TrackerChanged(newHouseAddress,Action.added);\n', '        emit TrackerChanged(oldHouseAddress,Action.updated);\n', '    }\n', '\n', '     /**\n', '     * Remove House function\n', '     *\n', '     * Removes a house\n', '     */\n', '    function removeHouse(address houseAddress) public {\n', '        require(!trackerData.managed || msg.sender==owner,"Tracker is managed");\n', '        require(houses[houseAddress].owner==msg.sender,"Caller isn\'t the owner of House");  \n', '        houses[houseAddress].isActive = false;\n', '        emit TrackerChanged(houseAddress,Action.updated);\n', '    }\n', '\n', '     /**\n', '     * UpVote House function\n', '     *\n', '     * UpVotes a house\n', '     */\n', '    function upVoteHouse(address houseAddress) public {\n', '        require(HouseContract(houseAddress).isPlayer(msg.sender),"Caller hasn\'t placed any bet");\n', '        require(!playerUpvoted[msg.sender][houseAddress],"Has already Upvoted");\n', '        playerUpvoted[msg.sender][houseAddress] = true;\n', '        houses[houseAddress].upVotes += 1;\n', '        emit TrackerChanged(houseAddress,Action.updated);\n', '    }\n', '\n', '     /**\n', '     * DownVote House function\n', '     *\n', '     * DownVotes a house\n', '     */\n', '    function downVoteHouse(address houseAddress) public {\n', '        require(HouseContract(houseAddress).isPlayer(msg.sender),"Caller hasn\'t placed any bet");\n', '        require(!playerDownvoted[msg.sender][houseAddress],"Has already Downvoted");\n', '        playerDownvoted[msg.sender][houseAddress] = true;\n', '        houses[houseAddress].downVotes += 1;\n', '        emit TrackerChanged(houseAddress,Action.updated);\n', '    }    \n', '\n', '    /**\n', '     * Kill function\n', '     *\n', '     * Contract Suicide\n', '     */\n', '    function kill() onlyOwner public {\n', '        selfdestruct(owner); \n', '    }\n', '\n', '}']