['pragma solidity ^0.4.24;\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'contract Subby {\n', '    event Post(address indexed publisherAddress, uint indexed postId, uint indexed timestamp, string publisherUsername, string link, string comment);\n', '    event Donation(address indexed recipientAddress, int indexed postId, address indexed senderAddress, string recipientUsername, string senderUsername, string text, uint amount, uint timestamp);\n', '\n', '    mapping(address => string) public addressToThumbnail;\n', '    mapping(address => string) public addressToBio;\n', '    mapping(address => string) public addressToUsername;\n', '    mapping(string => address) private usernameToAddress;\n', '    mapping(address => string[]) private addressToComments;\n', '    mapping(address => string[]) private addressToLinks;\n', '    mapping(address => uint[]) public addressToTimestamps;\n', '    mapping(address => uint) public addressToMinimumTextDonation;\n', '    mapping(address => string[]) private addressToSubscriptions;\n', '    mapping(address => bool) public addressToIsTerminated;\n', '    mapping(address => uint) public addressToTotalDonationsAmount;\n', '    mapping(address => mapping(uint => uint)) public addressToPostIdToDonationsAmount;\n', '    mapping(address => bool) public addressToHideDonationsAmounts;\n', '   \n', '    constructor() public {}\n', '\n', '    function terminateAccount() public {\n', '        addressToIsTerminated[msg.sender] = true;\n', '    }\n', '  \n', '    function donate(string text, address recipientAddress, string recipientUsername, int postId) public payable {\n', '        require(addressToIsTerminated[recipientAddress] == false, "Can\'t donate to terminated account.");\n', '       \n', '        if (bytes(recipientUsername).length > 0) {\n', '            recipientAddress = usernameToAddress[recipientUsername];\n', '        }\n', '        if (bytes(text).length > 0) {\n', '            require(addressToMinimumTextDonation[recipientAddress] > 0, "Recipient has disabled donations.");\n', '            require(msg.value >= addressToMinimumTextDonation[recipientAddress], "Donation amount lower than recipient minimum donation.");\n', '        }\n', '        recipientAddress.transfer(msg.value);\n', '        addressToTotalDonationsAmount[recipientAddress] += msg.value;\n', '        if (postId >= 0) {\n', '            addressToPostIdToDonationsAmount[recipientAddress][uint(postId)] += msg.value;\n', '        }\n', '        if (msg.value > addressToMinimumTextDonation[recipientAddress] && addressToMinimumTextDonation[recipientAddress] > 0) {\n', '            if (postId < 0) {\n', '                postId = -1;\n', '            }\n', '            if (bytes(text).length > 0) {\n', '                emit Donation(recipientAddress, postId, msg.sender, addressToUsername[recipientAddress], addressToUsername[msg.sender], text, msg.value, now);\n', '            }\n', '        }\n', '    }\n', '\n', '    function publish(string link, string comment) public {\n', '        require(addressToIsTerminated[msg.sender] == false, "Terminated accounts may not publish.");\n', '        uint id = addressToComments[msg.sender].push(comment);\n', '        addressToLinks[msg.sender].push(link);\n', '        addressToTimestamps[msg.sender].push(now);\n', '\n', '        emit Post(msg.sender, id, now, addressToUsername[msg.sender], link, comment);\n', '    }\n', '\n', '    function setMinimumTextDonation (uint value) public {\n', '        addressToMinimumTextDonation[msg.sender] = value;\n', '    }\n', '\n', '    function setThumbnail(string thumbnail) public {\n', '        addressToThumbnail[msg.sender] = thumbnail;\n', '    }\n', '\n', '    function setBio(string bio) public {\n', '        addressToBio[msg.sender] = bio;\n', '    }\n', '\n', '    function editProfile(string thumbnail, bool changeThumbnail, string bio, bool changeBio, uint minimumTextDonation, bool changeMinimumTextDonation, bool hideDonations, bool changeHideDonations, string username, bool changeUsername) public {\n', '        require(addressToIsTerminated[msg.sender] == false, "Cant not edit terminated account.");\n', '        if (changeHideDonations) {\n', '            addressToHideDonationsAmounts[msg.sender] = hideDonations;\n', '        }\n', '        if (changeMinimumTextDonation) {\n', '            require(minimumTextDonation > 0, "Can not set minimumTextDonation to less than 0.");\n', '            addressToMinimumTextDonation[msg.sender] = minimumTextDonation;\n', '        }\n', '        if (changeThumbnail) {\n', '            addressToThumbnail[msg.sender] = thumbnail;\n', '        }\n', '        if (changeBio) {\n', '            addressToBio[msg.sender] = bio;\n', '        }\n', '        if (changeUsername) {\n', '            require(bytes(username).length < 39, "Username can not have more than 39 characters.");\n', '            require(bytes(username).length > 0, "Username must be longer than 0 characters.");\n', '            // Require that the name has not already been taken.\n', '            require(usernameToAddress[username] == 0x0000000000000000000000000000000000000000, "Usernames can not be changed.");\n', '            // Require that the sender has not already set a name.\n', '            require(bytes(addressToUsername[msg.sender]).length == 0, "This username is already taken.");\n', '            addressToUsername[msg.sender] = username;\n', '            usernameToAddress[username] = msg.sender;\n', '        }\n', '    }\n', '\n', '    function getProfile(address _address, string username) public view returns (address, string, uint, string[], uint, bool[]) {\n', '        string[] memory bio_thumbnail = new string[](2);\n', '        bool[] memory hideDonations_isTerminated = new bool[](2);\n', '        hideDonations_isTerminated[0] = addressToHideDonationsAmounts[_address];\n', '        hideDonations_isTerminated[1] = addressToIsTerminated[_address];\n', '        \n', '        if (addressToIsTerminated[_address]) {\n', '            return (0x0000000000000000000000000000000000000000, "", 0, bio_thumbnail, 0, hideDonations_isTerminated);\n', '        }\n', '\n', '        if (bytes(username).length > 0) {\n', '            _address = usernameToAddress[username];\n', '        }\n', '\n', '        bio_thumbnail[0] = getBio(_address);\n', '        bio_thumbnail[1] = getThumbnail(_address);\n', '        \n', '        return (_address, addressToUsername[_address], addressToMinimumTextDonation[_address], bio_thumbnail,\n', '            getTotalDonationsAmount(_address), hideDonations_isTerminated);\n', '    }\n', '\n', '    function getProfiles(address[] memory addresses, string[] memory usernames) public view returns (address[] memory, string[] memory, uint[]) {\n', '        address[] memory addressesFromUsernames = getAddressesFromUsernames(usernames);\n', '        string[] memory thumbnails_bios_usernames = new string[]((addresses.length + addressesFromUsernames.length) * 3);\n', '        address[] memory returnAddresses = new address[](addresses.length + addressesFromUsernames.length);\n', '        uint[] memory minimumTextDonations_totalDonationsAmounts = new uint[]((addresses.length + addressesFromUsernames.length) * 2);\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            thumbnails_bios_usernames[i] = getThumbnail(addresses[i]);\n', '            thumbnails_bios_usernames[i + addresses.length + addressesFromUsernames.length] = getBio(addresses[i]);\n', '            thumbnails_bios_usernames[i + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addresses[i]);\n', '            returnAddresses[i] = addresses[i];\n', '            minimumTextDonations_totalDonationsAmounts[i] = getMinimumTextDonation(addresses[i]);\n', '            minimumTextDonations_totalDonationsAmounts[i + addresses.length + addressesFromUsernames.length] = getTotalDonationsAmount(addresses[i]);\n', '        }\n', '        for (i = 0; i < addressesFromUsernames.length; i++) {\n', '            thumbnails_bios_usernames[i + addresses.length] = getThumbnail(addressesFromUsernames[i]);\n', '            thumbnails_bios_usernames[i + addresses.length + addresses.length + addressesFromUsernames.length] = getBio(addressesFromUsernames[i]);\n', '            thumbnails_bios_usernames[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addressesFromUsernames[i]);\n', '            returnAddresses[i + addresses.length] = addressesFromUsernames[i];\n', '            minimumTextDonations_totalDonationsAmounts[i + addresses.length] = getMinimumTextDonation(addressesFromUsernames[i]);\n', '            minimumTextDonations_totalDonationsAmounts[i + addresses.length + addresses.length + addressesFromUsernames.length] = getTotalDonationsAmount(addressesFromUsernames[i]);\n', '        }\n', '        return (returnAddresses, thumbnails_bios_usernames, minimumTextDonations_totalDonationsAmounts);\n', '    }\n', '        \n', '    function getSubscriptions(address _address, string username) public view returns (string[]) {\n', '        if (bytes(username).length > 0) {\n', '            _address = usernameToAddress[username];\n', '        }\n', '        return addressToSubscriptions[_address];\n', '    }\n', '\n', '    function getSubscriptionsFromSender() public view returns (string[]) {\n', '        return addressToSubscriptions[msg.sender];\n', '    }\n', '    \n', '    function syncSubscriptions(string[] subsToPush, string[] subsToOverwrite, uint[] indexesToOverwrite ) public {\n', '        for (uint i = 0; i < indexesToOverwrite.length; i++ ) {\n', '            addressToSubscriptions[msg.sender][indexesToOverwrite[i]] = subsToOverwrite[i];\n', '        }\n', '        for ( i = 0; i < subsToPush.length; i++) {\n', '            addressToSubscriptions[msg.sender].push(subsToPush[i]);\n', '        }\n', '    }\n', '\n', '    function getUsernameFromAddress(address _address) public view returns (string) {\n', '        return addressToUsername[_address];\n', '    }\n', '\n', '    function getAddressFromUsername(string username) public view returns (address) {\n', '        return usernameToAddress[username];\n', '    }\n', '\n', '    function getAddressesFromUsernames(string[] usernames) public view returns (address[]) {\n', '        address[] memory returnAddresses = new address[](usernames.length);\n', '        for (uint i = 0; i < usernames.length; i++) {\n', '            returnAddresses[i] = usernameToAddress[usernames[i]];\n', '        }\n', '        return returnAddresses;\n', '    }\n', '    \n', '    function getComment(address _address, uint id) public view returns (string) {\n', '        if (addressToIsTerminated[_address]) {\n', '            return "";\n', '        }\n', '        string[] memory comments = addressToComments[_address];\n', '        if (comments.length > id) {\n', '            return comments[id];\n', '        }\n', '        else {\n', '            return "";\n', '        }\n', '    }\n', '    \n', '    function getThumbnail(address _address) public view returns (string) {\n', '        if (addressToIsTerminated[_address]) {\n', '            return "";\n', '        }\n', '        return addressToThumbnail[_address];\n', '    }\n', '    \n', '    function getLink(address _address, uint id) public view returns (string) {\n', '        if (addressToIsTerminated[_address]) {\n', '            return "";\n', '        }\n', '        string[] memory links = addressToLinks[_address];\n', '        if (links.length > id) {\n', '            return links[id];\n', '        }\n', '        else {\n', '            return "";\n', '        }\n', '    }\n', '\n', '    function getBio(address _address) public view returns (string) {\n', '        if (addressToIsTerminated[_address]) {\n', '            return "";\n', '        }\n', '        return addressToBio[_address];\n', '    }\n', '\n', '    function getTimestamp(address _address, uint id) public view returns (uint) {\n', '        if (addressToIsTerminated[_address]) {\n', '            return 0;\n', '        }\n', '        uint[] memory timestamps = addressToTimestamps[_address];\n', '        if (timestamps.length > id) {\n', '            return timestamps[id];\n', '        }\n', '        else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function getTotalDonationsAmount(address _address) public view returns (uint) {\n', '        if (addressToHideDonationsAmounts[_address]) {\n', '            return 0;\n', '        }\n', '        return addressToTotalDonationsAmount[_address];\n', '    }\n', '    \n', '    function getMinimumTextDonation(address _address) public view returns (uint) {\n', '        return addressToMinimumTextDonation[_address];\n', '    }\n', '    \n', '    function getUsername(address _address) public view returns (string) {\n', '        return addressToUsername[_address];\n', '    }\n', '\n', '    function getLinks(address _address) public view returns (string[]) {\n', '        return addressToLinks[_address];\n', '    }\n', '\n', '    function getComments(address _address) public view returns (string[]) {\n', '        return addressToComments[_address];\n', '    }\n', '\n', '    function getTimestamps(address _address) public view returns (uint[]) {\n', '        return addressToTimestamps[_address];\n', '    }\n', '\n', '    function getPostFromId(address _address, string username,  uint id) public view returns ( string[], address, uint, uint, uint) {\n', '        if (bytes(username).length > 0) {\n', '            _address = usernameToAddress[username];\n', '        }\n', '        string[] memory comment_link_username_thumbnail = new string[](4);\n', '        comment_link_username_thumbnail[0] = getComment(_address, id);\n', '        comment_link_username_thumbnail[1] = getLink(_address, id);\n', '        comment_link_username_thumbnail[2] = getUsername(_address);\n', '        comment_link_username_thumbnail[3] = addressToThumbnail[_address];\n', '        uint timestamp = getTimestamp(_address, id);\n', '        uint postDonationsAmount = getPostDonationsAmount(_address, id);\n', '\n', '        return (comment_link_username_thumbnail, _address,  timestamp,  addressToMinimumTextDonation[_address], postDonationsAmount);\n', '    }\n', '    \n', '    function getPostDonationsAmount(address _address, uint id) public view returns (uint) {\n', '        if (addressToHideDonationsAmounts[_address]) {\n', '            return 0;\n', '        }\n', '        return addressToPostIdToDonationsAmount[_address][id];\n', '    }\n', '\n', '    function getPostsFromIds(address[] addresses, string[] usernames, uint[] ids) public view returns (string[], address[], uint[]) {\n', '        address[] memory addressesFromUsernames = getAddressesFromUsernames(usernames);\n', '        string[] memory comments_links_usernames_thumbnails = new string[]((addresses.length + addressesFromUsernames.length) * 4);\n', '        address[] memory publisherAddresses = new address[](addresses.length + addressesFromUsernames.length);\n', '        uint[] memory minimumTextDonations_postDonationsAmount_timestamps = new uint[]((addresses.length + addressesFromUsernames.length) * 3);\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            comments_links_usernames_thumbnails[i] = getComment(addresses[i], ids[i]);\n', '            comments_links_usernames_thumbnails[i + addresses.length + addressesFromUsernames.length] = getLink(addresses[i], ids[i]);\n', '            comments_links_usernames_thumbnails[i + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addresses[i]);\n', '            comments_links_usernames_thumbnails[i + ((addresses.length + addressesFromUsernames.length) * 3)] = getThumbnail(addresses[i]);\n', '            publisherAddresses[i] = addresses[i];\n', '            minimumTextDonations_postDonationsAmount_timestamps[i] = getMinimumTextDonation(addresses[i]);\n', '            minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length + addressesFromUsernames.length] = getPostDonationsAmount(addresses[i], ids[i]);\n', '            minimumTextDonations_postDonationsAmount_timestamps[i + ((addresses.length + addressesFromUsernames.length) * 2)] = getTimestamp(addresses[i], ids[i]);\n', '        }\n', '        \n', '        for (i = 0; i < addressesFromUsernames.length; i++) {\n', '            comments_links_usernames_thumbnails[i + addresses.length] = getComment(addressesFromUsernames[i], ids[i + addresses.length]);\n', '            comments_links_usernames_thumbnails[i + addresses.length + (addresses.length + addressesFromUsernames.length)] = getLink(addressesFromUsernames[i], ids[i + addresses.length]);\n', '            comments_links_usernames_thumbnails[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 2)] = getUsername(addressesFromUsernames[i]);\n', '            comments_links_usernames_thumbnails[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 3)] = getThumbnail(addressesFromUsernames[i]);\n', '            publisherAddresses[i + addresses.length] = addressesFromUsernames[i];\n', '            minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length] = getMinimumTextDonation(addressesFromUsernames[i]);\n', '            minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length + (addresses.length + addressesFromUsernames.length)] = getPostDonationsAmount(addressesFromUsernames[i], ids[i + addresses.length]);\n', '            minimumTextDonations_postDonationsAmount_timestamps[i + addresses.length + ((addresses.length + addressesFromUsernames.length) * 2)] = getTimestamp(addressesFromUsernames[i], ids[i + addresses.length]);\n', '        }\n', '        \n', '        return (comments_links_usernames_thumbnails, publisherAddresses, minimumTextDonations_postDonationsAmount_timestamps);\n', '    }\n', '    \n', '    function getPostsFromPublisher(address _address, string username, uint startAt, bool startAtLatestPost, uint limit)\n', '        public view returns (string[], string[], address, uint[]) {\n', '        if (bytes(username).length > 0) {\n', '            _address = usernameToAddress[username];\n', '        }\n', '        string[] memory comments_links = new string[](limit * 2);\n', '        string[] memory thumbnail_username = new string[](2);\n', '        thumbnail_username[0] = addressToThumbnail[_address];\n', '        thumbnail_username[1] = addressToUsername[_address];\n', '        if (startAtLatestPost == true) {\n', '            startAt = addressToComments[_address].length;\n', '        }\n', '        uint[] memory timestamps_postDonationsAmounts_minimumTextDonation_postCount = new uint[]((limit * 2) + 2);\n', '\n', '        parseCommentsLinks(comments_links, _address, startAt, limit, timestamps_postDonationsAmounts_minimumTextDonation_postCount);\n', '        timestamps_postDonationsAmounts_minimumTextDonation_postCount[limit * 2] = addressToMinimumTextDonation[_address];\n', '        timestamps_postDonationsAmounts_minimumTextDonation_postCount[(limit * 2) + 1] = addressToComments[_address].length;\n', '        \n', '        return (comments_links, thumbnail_username, _address, timestamps_postDonationsAmounts_minimumTextDonation_postCount );\n', '    }\n', '    \n', '    function parseCommentsLinks(string[] comments_links, \n', '        address _address, uint startAt, uint limit, uint[] timestamps_postDonationsAmounts_minimumTextDonation_postCount) public view {\n', '        uint count = 0;\n', '        for (uint i = 1; i < limit + 1; i++) {\n', '            comments_links[count] = getComment(_address, startAt - i);\n', '            timestamps_postDonationsAmounts_minimumTextDonation_postCount[count] = getTimestamp(_address, startAt - i);\n', '            timestamps_postDonationsAmounts_minimumTextDonation_postCount[count + limit] = getPostDonationsAmount(_address, startAt - i);\n', '            count++;\n', '        } \n', '        for (i = 1; i < limit + 1; i++) {\n', '            comments_links[count] = getLink(_address, startAt - i);\n', '            count++;\n', '        } \n', '    }\n', '\n', '    function getTimestampsFromPublishers(address[] addresses, string[] usernames, int[] startAts, int limit) public view returns (uint[], uint[]) {\n', '        uint[] memory returnTimestamps = new uint[]((addresses.length + usernames.length) * uint(limit));\n', '        uint[] memory publisherPostCounts = new uint[](addresses.length + usernames.length);\n', '        uint timestampIndex = 0;\n', '        uint addressesPlusUsernamesIndex = 0;\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            address _address = addresses[i];\n', '            // startAt is the first index that will be returned.\n', '            int startAt;\n', '            if (startAts.length == 0) {\n', '                startAt = int(addressToTimestamps[_address].length - 1);\n', '            } else {\n', '                startAt = startAts[addressesPlusUsernamesIndex];\n', '            }\n', '            // Collect timestamps, starting from startAt and counting down to 0 until limit is reached.\n', '            for (int j = 0; j < limit; j++) {\n', '                if (addressToIsTerminated[_address] == false && ((startAt - j) >= 0) && ((startAt - j) < int(addressToTimestamps[_address].length))) {\n', '                    returnTimestamps[timestampIndex] = addressToTimestamps[_address][uint(startAt - j)];\n', '                } else {\n', '                    returnTimestamps[timestampIndex] = 0;\n', '                }\n', '                timestampIndex++;\n', '            }\n', '            publisherPostCounts[addressesPlusUsernamesIndex] = addressToTimestamps[_address].length;\n', '            addressesPlusUsernamesIndex++;\n', '        }\n', '        // Do the same thing as above, but with usernames instead of addresses. Code duplication is essential to save gas.\n', '        if (usernames.length > 0) {\n', '            addresses = getAddressesFromUsernames(usernames);\n', '            for (i = 0; i < addresses.length; i++) {\n', '                _address = addresses[i];\n', '                if (startAts.length == 0) {\n', '                    startAt = int(addressToTimestamps[_address].length - 1);\n', '                } else {\n', '                    startAt = startAts[addressesPlusUsernamesIndex];\n', '                }\n', '                for (j = 0; j < limit; j++) {\n', '                    if (addressToIsTerminated[_address] == false && ((startAt - j) >= 0) && ((startAt - j) < int(addressToTimestamps[_address].length))) {\n', '                        returnTimestamps[timestampIndex] = addressToTimestamps[_address][uint(startAt - j)];\n', '                    } else {\n', '                        returnTimestamps[timestampIndex] = 0;\n', '                    }\n', '                    timestampIndex++;\n', '                }\n', '                publisherPostCounts[addressesPlusUsernamesIndex] = addressToTimestamps[_address].length;\n', '                addressesPlusUsernamesIndex++;\n', '            }\n', '        }\n', '        return (returnTimestamps, publisherPostCounts);\n', '    }\n', '}']