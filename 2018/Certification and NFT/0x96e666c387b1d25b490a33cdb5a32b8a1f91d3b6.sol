['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract FishbankBoosters is Ownable {\n', '\n', '    struct Booster {\n', '        address owner;\n', '        uint32 duration;\n', '        uint8 boosterType;\n', '        uint24 raiseValue;\n', '        uint8 strength;\n', '        uint32 amount;\n', '    }\n', '\n', '    Booster[] public boosters;\n', '    bool public implementsERC721 = true;\n', '    string public name = "Fishbank Boosters";\n', '    string public symbol = "FISHB";\n', '    mapping(uint256 => address) public approved;\n', '    mapping(address => uint256) public balances;\n', '    address public fishbank;\n', '    address public chests;\n', '    address public auction;\n', '\n', '    modifier onlyBoosterOwner(uint256 _tokenId) {\n', '        require(boosters[_tokenId].owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier onlyChest() {\n', '        require(chests == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function FishbankBoosters() public {\n', '        //nothing yet\n', '    }\n', '\n', '    //mints the boosters can only be called by owner. could be a smart contract\n', '    function mintBooster(address _owner, uint32 _duration, uint8 _type, uint8 _strength, uint32 _amount, uint24 _raiseValue) onlyChest public {\n', '        boosters.length ++;\n', '\n', '        Booster storage tempBooster = boosters[boosters.length - 1];\n', '\n', '        tempBooster.owner = _owner;\n', '        tempBooster.duration = _duration;\n', '        tempBooster.boosterType = _type;\n', '        tempBooster.strength = _strength;\n', '        tempBooster.amount = _amount;\n', '        tempBooster.raiseValue = _raiseValue;\n', '\n', '        Transfer(address(0), _owner, boosters.length - 1);\n', '    }\n', '\n', '    function setFishbank(address _fishbank) onlyOwner public {\n', '        fishbank = _fishbank;\n', '    }\n', '\n', '    function setChests(address _chests) onlyOwner public {\n', '        if (chests != address(0)) {\n', '            revert();\n', '        }\n', '        chests = _chests;\n', '    }\n', '\n', '    function setAuction(address _auction) onlyOwner public {\n', '        auction = _auction;\n', '    }\n', '\n', '    function getBoosterType(uint256 _tokenId) view public returns (uint8 boosterType) {\n', '        boosterType = boosters[_tokenId].boosterType;\n', '    }\n', '\n', '    function getBoosterAmount(uint256 _tokenId) view public returns (uint32 boosterAmount) {\n', '        boosterAmount = boosters[_tokenId].amount;\n', '    }\n', '\n', '    function getBoosterDuration(uint256 _tokenId) view public returns (uint32) {\n', '        if (boosters[_tokenId].boosterType == 4 || boosters[_tokenId].boosterType == 2) {\n', '            return boosters[_tokenId].duration + boosters[_tokenId].raiseValue * 60;\n', '        }\n', '        return boosters[_tokenId].duration;\n', '    }\n', '\n', '    function getBoosterStrength(uint256 _tokenId) view public returns (uint8 strength) {\n', '        strength = boosters[_tokenId].strength;\n', '    }\n', '\n', '    function getBoosterRaiseValue(uint256 _tokenId) view public returns (uint24 raiseValue) {\n', '        raiseValue = boosters[_tokenId].raiseValue;\n', '    }\n', '\n', '    //ERC721 functionality\n', '    //could split this to a different contract but doesn&#39;t make it easier to read\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    function totalSupply() public view returns (uint256 total) {\n', '        total = boosters.length;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance){\n', '        balance = balances[_owner];\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner){\n', '        owner = boosters[_tokenId].owner;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '        require(boosters[_tokenId].owner == _from);\n', '        //can only transfer if previous owner equals from\n', '        boosters[_tokenId].owner = _to;\n', '        approved[_tokenId] = address(0);\n', '        //reset approved of fish on every transfer\n', '        balances[_from] -= 1;\n', '        //underflow can only happen on 0x\n', '        balances[_to] += 1;\n', '        //overflows only with very very large amounts of fish\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _tokenId) public\n', '    onlyBoosterOwner(_tokenId) //check if msg.sender is the owner of this fish\n', '    returns (bool)\n', '    {\n', '        _transfer(msg.sender, _to, _tokenId);\n', '        //after master modifier invoke internal transfer\n', '        return true;\n', '    }\n', '\n', '    function approve(address _to, uint256 _tokenId) public\n', '    onlyBoosterOwner(_tokenId)\n', '    {\n', '        approved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {\n', '        require(approved[_tokenId] == msg.sender || msg.sender == fishbank || msg.sender == auction);\n', '        //require msg.sender to be approved for this token or to be the fishbank contract\n', '        _transfer(_from, _to, _tokenId);\n', '        //handles event, balances and approval reset\n', '        return true;\n', '    }\n', '\n', '\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        require(approved[_tokenId] == msg.sender);\n', '        _transfer(ownerOf(_tokenId), msg.sender, _tokenId);\n', '    }\n', '\n', '\n', '}\n', '\n', '\n', 'contract FishbankChests is Ownable {\n', '\n', '    struct Chest {\n', '        address owner;\n', '        uint16 boosters;\n', '        uint16 chestType;\n', '        uint24 raiseChance;//Increace chance to catch bigger chest (1 = 1:10000)\n', '        uint8 onlySpecificType;\n', '        uint8 onlySpecificStrength;\n', '        uint24 raiseStrength;\n', '    }\n', '\n', '    Chest[] public chests;\n', '    FishbankBoosters public boosterContract;\n', '    mapping(uint256 => address) public approved;\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => bool) public minters;\n', '\n', '    modifier onlyChestOwner(uint256 _tokenId) {\n', '        require(chests[_tokenId].owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier onlyMinters() {\n', '        require(minters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function FishbankChests(address _boosterAddress) public {\n', '        boosterContract = FishbankBoosters(_boosterAddress);\n', '    }\n', '\n', '    function addMinter(address _minter) onlyOwner public {\n', '        minters[_minter] = true;\n', '    }\n', '\n', '    function removeMinter(address _minter) onlyOwner public {\n', '        minters[_minter] = false;\n', '    }\n', '\n', '    //create a chest\n', '\n', '    function mintChest(address _owner, uint16 _boosters, uint24 _raiseStrength, uint24 _raiseChance, uint8 _onlySpecificType, uint8 _onlySpecificStrength) onlyMinters public {\n', '\n', '        chests.length++;\n', '        chests[chests.length - 1].owner = _owner;\n', '        chests[chests.length - 1].boosters = _boosters;\n', '        chests[chests.length - 1].raiseStrength = _raiseStrength;\n', '        chests[chests.length - 1].raiseChance = _raiseChance;\n', '        chests[chests.length - 1].onlySpecificType = _onlySpecificType;\n', '        chests[chests.length - 1].onlySpecificStrength = _onlySpecificStrength;\n', '        Transfer(address(0), _owner, chests.length - 1);\n', '    }\n', '\n', '    function convertChest(uint256 _tokenId) onlyChestOwner(_tokenId) public {\n', '\n', '        Chest memory chest = chests[_tokenId];\n', '        uint16 numberOfBoosters = chest.boosters;\n', '\n', '        if (chest.onlySpecificType != 0) {//Specific boosters\n', '            if (chest.onlySpecificType == 1 || chest.onlySpecificType == 3) {\n', '                boosterContract.mintBooster(msg.sender, 2 days, chest.onlySpecificType, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);\n', '            } else if (chest.onlySpecificType == 5) {//Instant attack\n', '                boosterContract.mintBooster(msg.sender, 0, 5, 1, chest.boosters, chest.raiseStrength);\n', '            } else if (chest.onlySpecificType == 2) {//Freeze\n', '                uint32 freezeTime = 7 days;\n', '                if (chest.onlySpecificStrength == 2) {\n', '                    freezeTime = 14 days;\n', '                } else if (chest.onlySpecificStrength == 3) {\n', '                    freezeTime = 30 days;\n', '                }\n', '                boosterContract.mintBooster(msg.sender, freezeTime, 5, chest.onlySpecificType, chest.boosters, chest.raiseStrength);\n', '            } else if (chest.onlySpecificType == 4) {//Watch\n', '                uint32 watchTime = 12 hours;\n', '                if (chest.onlySpecificStrength == 2) {\n', '                    watchTime = 48 hours;\n', '                } else if (chest.onlySpecificStrength == 3) {\n', '                    watchTime = 3 days;\n', '                }\n', '                boosterContract.mintBooster(msg.sender, watchTime, 4, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);\n', '            }\n', '\n', '        } else {//Regular chest\n', '\n', '            for (uint8 i = 0; i < numberOfBoosters; i ++) {\n', '                uint24 random = uint16(keccak256(block.coinbase, block.blockhash(block.number - 1), i, chests.length)) % 1000\n', '                - chest.raiseChance;\n', '                //get random 0 - 9999 minus raiseChance\n', '\n', '                if (random > 850) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 1, 1, 1, chest.raiseStrength); //Small Agility Booster\n', '                } else if (random > 700) {\n', '                    boosterContract.mintBooster(msg.sender, 7 days, 2, 1, 1, chest.raiseStrength); //Small Freezer\n', '                } else if (random > 550) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 3, 1, 1, chest.raiseStrength); //Small Power Booster\n', '                } else if (random > 400) {\n', '                    boosterContract.mintBooster(msg.sender, 12 hours, 4, 1, 1, chest.raiseStrength); //Tiny Watch\n', '                } else if (random > 325) {\n', '                    boosterContract.mintBooster(msg.sender, 48 hours, 4, 2, 1, chest.raiseStrength); //Small Watch\n', '                } else if (random > 250) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 1, 2, 1, chest.raiseStrength); //Mid Agility Booster\n', '                } else if (random > 175) {\n', '                    boosterContract.mintBooster(msg.sender, 14 days, 2, 2, 1, chest.raiseStrength); //Mid Freezer\n', '                } else if (random > 100) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 3, 2, 1, chest.raiseStrength); //Mid Power Booster\n', '                } else if (random > 80) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 1, 3, 1, chest.raiseStrength); //Big Agility Booster\n', '                } else if (random > 60) {\n', '                    boosterContract.mintBooster(msg.sender, 30 days, 2, 3, 1, chest.raiseStrength); //Big Freezer\n', '                } else if (random > 40) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 3, 3, 1, chest.raiseStrength); //Big Power Booster\n', '                } else if (random > 20) {\n', '                    boosterContract.mintBooster(msg.sender, 0, 5, 1, 1, 0); //Instant Attack\n', '                } else {\n', '                    boosterContract.mintBooster(msg.sender, 3 days, 4, 3, 1, 0); //Gold Watch\n', '                }\n', '            }\n', '        }\n', '\n', '        _transfer(msg.sender, address(0), _tokenId); //burn chest\n', '    }\n', '\n', '    //ERC721 functionality\n', '    //could split this to a different contract but doesn&#39;t make it easier to read\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    function totalSupply() public view returns (uint256 total) {\n', '        total = chests.length;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance){\n', '        balance = balances[_owner];\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner){\n', '        owner = chests[_tokenId].owner;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '        require(chests[_tokenId].owner == _from); //can only transfer if previous owner equals from\n', '        chests[_tokenId].owner = _to;\n', '        approved[_tokenId] = address(0); //reset approved of fish on every transfer\n', '        balances[_from] -= 1; //underflow can only happen on 0x\n', '        balances[_to] += 1; //overflows only with very very large amounts of fish\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _tokenId) public\n', '    onlyChestOwner(_tokenId) //check if msg.sender is the owner of this fish\n', '    returns (bool)\n', '    {\n', '        _transfer(msg.sender, _to, _tokenId);\n', '        //after master modifier invoke internal transfer\n', '        return true;\n', '    }\n', '\n', '    function approve(address _to, uint256 _tokenId) public\n', '    onlyChestOwner(_tokenId)\n', '    {\n', '        approved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {\n', '        require(approved[_tokenId] == msg.sender);\n', '        //require msg.sender to be approved for this token\n', '        _transfer(_from, _to, _tokenId);\n', '        //handles event, balances and approval reset\n', '        return true;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract FishbankBoosters is Ownable {\n', '\n', '    struct Booster {\n', '        address owner;\n', '        uint32 duration;\n', '        uint8 boosterType;\n', '        uint24 raiseValue;\n', '        uint8 strength;\n', '        uint32 amount;\n', '    }\n', '\n', '    Booster[] public boosters;\n', '    bool public implementsERC721 = true;\n', '    string public name = "Fishbank Boosters";\n', '    string public symbol = "FISHB";\n', '    mapping(uint256 => address) public approved;\n', '    mapping(address => uint256) public balances;\n', '    address public fishbank;\n', '    address public chests;\n', '    address public auction;\n', '\n', '    modifier onlyBoosterOwner(uint256 _tokenId) {\n', '        require(boosters[_tokenId].owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier onlyChest() {\n', '        require(chests == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function FishbankBoosters() public {\n', '        //nothing yet\n', '    }\n', '\n', '    //mints the boosters can only be called by owner. could be a smart contract\n', '    function mintBooster(address _owner, uint32 _duration, uint8 _type, uint8 _strength, uint32 _amount, uint24 _raiseValue) onlyChest public {\n', '        boosters.length ++;\n', '\n', '        Booster storage tempBooster = boosters[boosters.length - 1];\n', '\n', '        tempBooster.owner = _owner;\n', '        tempBooster.duration = _duration;\n', '        tempBooster.boosterType = _type;\n', '        tempBooster.strength = _strength;\n', '        tempBooster.amount = _amount;\n', '        tempBooster.raiseValue = _raiseValue;\n', '\n', '        Transfer(address(0), _owner, boosters.length - 1);\n', '    }\n', '\n', '    function setFishbank(address _fishbank) onlyOwner public {\n', '        fishbank = _fishbank;\n', '    }\n', '\n', '    function setChests(address _chests) onlyOwner public {\n', '        if (chests != address(0)) {\n', '            revert();\n', '        }\n', '        chests = _chests;\n', '    }\n', '\n', '    function setAuction(address _auction) onlyOwner public {\n', '        auction = _auction;\n', '    }\n', '\n', '    function getBoosterType(uint256 _tokenId) view public returns (uint8 boosterType) {\n', '        boosterType = boosters[_tokenId].boosterType;\n', '    }\n', '\n', '    function getBoosterAmount(uint256 _tokenId) view public returns (uint32 boosterAmount) {\n', '        boosterAmount = boosters[_tokenId].amount;\n', '    }\n', '\n', '    function getBoosterDuration(uint256 _tokenId) view public returns (uint32) {\n', '        if (boosters[_tokenId].boosterType == 4 || boosters[_tokenId].boosterType == 2) {\n', '            return boosters[_tokenId].duration + boosters[_tokenId].raiseValue * 60;\n', '        }\n', '        return boosters[_tokenId].duration;\n', '    }\n', '\n', '    function getBoosterStrength(uint256 _tokenId) view public returns (uint8 strength) {\n', '        strength = boosters[_tokenId].strength;\n', '    }\n', '\n', '    function getBoosterRaiseValue(uint256 _tokenId) view public returns (uint24 raiseValue) {\n', '        raiseValue = boosters[_tokenId].raiseValue;\n', '    }\n', '\n', '    //ERC721 functionality\n', "    //could split this to a different contract but doesn't make it easier to read\n", '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    function totalSupply() public view returns (uint256 total) {\n', '        total = boosters.length;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance){\n', '        balance = balances[_owner];\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner){\n', '        owner = boosters[_tokenId].owner;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '        require(boosters[_tokenId].owner == _from);\n', '        //can only transfer if previous owner equals from\n', '        boosters[_tokenId].owner = _to;\n', '        approved[_tokenId] = address(0);\n', '        //reset approved of fish on every transfer\n', '        balances[_from] -= 1;\n', '        //underflow can only happen on 0x\n', '        balances[_to] += 1;\n', '        //overflows only with very very large amounts of fish\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _tokenId) public\n', '    onlyBoosterOwner(_tokenId) //check if msg.sender is the owner of this fish\n', '    returns (bool)\n', '    {\n', '        _transfer(msg.sender, _to, _tokenId);\n', '        //after master modifier invoke internal transfer\n', '        return true;\n', '    }\n', '\n', '    function approve(address _to, uint256 _tokenId) public\n', '    onlyBoosterOwner(_tokenId)\n', '    {\n', '        approved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {\n', '        require(approved[_tokenId] == msg.sender || msg.sender == fishbank || msg.sender == auction);\n', '        //require msg.sender to be approved for this token or to be the fishbank contract\n', '        _transfer(_from, _to, _tokenId);\n', '        //handles event, balances and approval reset\n', '        return true;\n', '    }\n', '\n', '\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        require(approved[_tokenId] == msg.sender);\n', '        _transfer(ownerOf(_tokenId), msg.sender, _tokenId);\n', '    }\n', '\n', '\n', '}\n', '\n', '\n', 'contract FishbankChests is Ownable {\n', '\n', '    struct Chest {\n', '        address owner;\n', '        uint16 boosters;\n', '        uint16 chestType;\n', '        uint24 raiseChance;//Increace chance to catch bigger chest (1 = 1:10000)\n', '        uint8 onlySpecificType;\n', '        uint8 onlySpecificStrength;\n', '        uint24 raiseStrength;\n', '    }\n', '\n', '    Chest[] public chests;\n', '    FishbankBoosters public boosterContract;\n', '    mapping(uint256 => address) public approved;\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => bool) public minters;\n', '\n', '    modifier onlyChestOwner(uint256 _tokenId) {\n', '        require(chests[_tokenId].owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    modifier onlyMinters() {\n', '        require(minters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function FishbankChests(address _boosterAddress) public {\n', '        boosterContract = FishbankBoosters(_boosterAddress);\n', '    }\n', '\n', '    function addMinter(address _minter) onlyOwner public {\n', '        minters[_minter] = true;\n', '    }\n', '\n', '    function removeMinter(address _minter) onlyOwner public {\n', '        minters[_minter] = false;\n', '    }\n', '\n', '    //create a chest\n', '\n', '    function mintChest(address _owner, uint16 _boosters, uint24 _raiseStrength, uint24 _raiseChance, uint8 _onlySpecificType, uint8 _onlySpecificStrength) onlyMinters public {\n', '\n', '        chests.length++;\n', '        chests[chests.length - 1].owner = _owner;\n', '        chests[chests.length - 1].boosters = _boosters;\n', '        chests[chests.length - 1].raiseStrength = _raiseStrength;\n', '        chests[chests.length - 1].raiseChance = _raiseChance;\n', '        chests[chests.length - 1].onlySpecificType = _onlySpecificType;\n', '        chests[chests.length - 1].onlySpecificStrength = _onlySpecificStrength;\n', '        Transfer(address(0), _owner, chests.length - 1);\n', '    }\n', '\n', '    function convertChest(uint256 _tokenId) onlyChestOwner(_tokenId) public {\n', '\n', '        Chest memory chest = chests[_tokenId];\n', '        uint16 numberOfBoosters = chest.boosters;\n', '\n', '        if (chest.onlySpecificType != 0) {//Specific boosters\n', '            if (chest.onlySpecificType == 1 || chest.onlySpecificType == 3) {\n', '                boosterContract.mintBooster(msg.sender, 2 days, chest.onlySpecificType, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);\n', '            } else if (chest.onlySpecificType == 5) {//Instant attack\n', '                boosterContract.mintBooster(msg.sender, 0, 5, 1, chest.boosters, chest.raiseStrength);\n', '            } else if (chest.onlySpecificType == 2) {//Freeze\n', '                uint32 freezeTime = 7 days;\n', '                if (chest.onlySpecificStrength == 2) {\n', '                    freezeTime = 14 days;\n', '                } else if (chest.onlySpecificStrength == 3) {\n', '                    freezeTime = 30 days;\n', '                }\n', '                boosterContract.mintBooster(msg.sender, freezeTime, 5, chest.onlySpecificType, chest.boosters, chest.raiseStrength);\n', '            } else if (chest.onlySpecificType == 4) {//Watch\n', '                uint32 watchTime = 12 hours;\n', '                if (chest.onlySpecificStrength == 2) {\n', '                    watchTime = 48 hours;\n', '                } else if (chest.onlySpecificStrength == 3) {\n', '                    watchTime = 3 days;\n', '                }\n', '                boosterContract.mintBooster(msg.sender, watchTime, 4, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);\n', '            }\n', '\n', '        } else {//Regular chest\n', '\n', '            for (uint8 i = 0; i < numberOfBoosters; i ++) {\n', '                uint24 random = uint16(keccak256(block.coinbase, block.blockhash(block.number - 1), i, chests.length)) % 1000\n', '                - chest.raiseChance;\n', '                //get random 0 - 9999 minus raiseChance\n', '\n', '                if (random > 850) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 1, 1, 1, chest.raiseStrength); //Small Agility Booster\n', '                } else if (random > 700) {\n', '                    boosterContract.mintBooster(msg.sender, 7 days, 2, 1, 1, chest.raiseStrength); //Small Freezer\n', '                } else if (random > 550) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 3, 1, 1, chest.raiseStrength); //Small Power Booster\n', '                } else if (random > 400) {\n', '                    boosterContract.mintBooster(msg.sender, 12 hours, 4, 1, 1, chest.raiseStrength); //Tiny Watch\n', '                } else if (random > 325) {\n', '                    boosterContract.mintBooster(msg.sender, 48 hours, 4, 2, 1, chest.raiseStrength); //Small Watch\n', '                } else if (random > 250) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 1, 2, 1, chest.raiseStrength); //Mid Agility Booster\n', '                } else if (random > 175) {\n', '                    boosterContract.mintBooster(msg.sender, 14 days, 2, 2, 1, chest.raiseStrength); //Mid Freezer\n', '                } else if (random > 100) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 3, 2, 1, chest.raiseStrength); //Mid Power Booster\n', '                } else if (random > 80) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 1, 3, 1, chest.raiseStrength); //Big Agility Booster\n', '                } else if (random > 60) {\n', '                    boosterContract.mintBooster(msg.sender, 30 days, 2, 3, 1, chest.raiseStrength); //Big Freezer\n', '                } else if (random > 40) {\n', '                    boosterContract.mintBooster(msg.sender, 2 days, 3, 3, 1, chest.raiseStrength); //Big Power Booster\n', '                } else if (random > 20) {\n', '                    boosterContract.mintBooster(msg.sender, 0, 5, 1, 1, 0); //Instant Attack\n', '                } else {\n', '                    boosterContract.mintBooster(msg.sender, 3 days, 4, 3, 1, 0); //Gold Watch\n', '                }\n', '            }\n', '        }\n', '\n', '        _transfer(msg.sender, address(0), _tokenId); //burn chest\n', '    }\n', '\n', '    //ERC721 functionality\n', "    //could split this to a different contract but doesn't make it easier to read\n", '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '\n', '    function totalSupply() public view returns (uint256 total) {\n', '        total = chests.length;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance){\n', '        balance = balances[_owner];\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner){\n', '        owner = chests[_tokenId].owner;\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '        require(chests[_tokenId].owner == _from); //can only transfer if previous owner equals from\n', '        chests[_tokenId].owner = _to;\n', '        approved[_tokenId] = address(0); //reset approved of fish on every transfer\n', '        balances[_from] -= 1; //underflow can only happen on 0x\n', '        balances[_to] += 1; //overflows only with very very large amounts of fish\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _tokenId) public\n', '    onlyChestOwner(_tokenId) //check if msg.sender is the owner of this fish\n', '    returns (bool)\n', '    {\n', '        _transfer(msg.sender, _to, _tokenId);\n', '        //after master modifier invoke internal transfer\n', '        return true;\n', '    }\n', '\n', '    function approve(address _to, uint256 _tokenId) public\n', '    onlyChestOwner(_tokenId)\n', '    {\n', '        approved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {\n', '        require(approved[_tokenId] == msg.sender);\n', '        //require msg.sender to be approved for this token\n', '        _transfer(_from, _to, _tokenId);\n', '        //handles event, balances and approval reset\n', '        return true;\n', '    }\n', '\n', '}']
