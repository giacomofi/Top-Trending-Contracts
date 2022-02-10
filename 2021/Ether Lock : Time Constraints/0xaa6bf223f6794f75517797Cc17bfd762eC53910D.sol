['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-26\n', '*/\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '\n', '/**\n', ' * @title TokenVesting\n', ' * @dev A token holder contract that can release its token balance gradually like a\n', ' * typical vesting scheme, with a cliff and vesting period.\n', ' */\n', 'contract CookDistribution  {\n', '\n', '\n', '    event AllocationRegistered(address indexed beneficiary, uint256 amount);\n', '    event TokensWithdrawal(address userAddress, uint256 amount);\n', '\n', '    struct Allocation {\n', '        uint256 amount;\n', '        uint256 released;\n', '        bool blackListed;\n', '        bool isRegistered;\n', '    }\n', '\n', '    // beneficiary of tokens after they are released\n', '    mapping(address => Allocation) private _beneficiaryAllocations;\n', '\n', '    // oracle price data (dayNumber => price)\n', '    mapping(uint256 => uint256) private _oraclePriceFeed;\n', '\n', '    // all beneficiary address1\n', '    address[] private _allBeneficiary;\n', '\n', ' \n', '    function addAddressWithAllocation(address beneficiaryAddress, uint256 amount ) public  {\n', '\n', '        require(\n', '            _beneficiaryAllocations[beneficiaryAddress].isRegistered == false,\n', '            "The address to be added already exisits in the distribution contact, please use a new one"\n', '        );\n', '\n', '        _beneficiaryAllocations[beneficiaryAddress].isRegistered = true;\n', '        _beneficiaryAllocations[beneficiaryAddress] = Allocation( amount, 0, false, true\n', '        );\n', '\n', '        emit AllocationRegistered(beneficiaryAddress, amount);\n', '    }\n', '\n', '    \n', '    function addMultipleAddressWithAllocations(address[] memory beneficiaryAddresses, uint256[] memory amounts) public {\n', '\n', '        require(beneficiaryAddresses.length > 0 && amounts.length > 0 && beneficiaryAddresses.length == amounts.length,\n', '            "The length of user addressed and amounts should be matched and cannot be empty"\n', '        );\n', '\n', '        for (uint256 i = 0; i < beneficiaryAddresses.length; i++) {\n', '            require(_beneficiaryAllocations[beneficiaryAddresses[i]].isRegistered == false,\n', '                "The address to be added already exisits in the distribution contact, please use a new one"\n', '            );\n', '        }\n', '\n', '        for (uint256 i = 0; i < beneficiaryAddresses.length; i++) {\n', '            _beneficiaryAllocations[beneficiaryAddresses[i]].isRegistered = true;\n', '            _beneficiaryAllocations[beneficiaryAddresses[i]] = Allocation(amounts[i], 0, false, true);\n', '\n', '            emit AllocationRegistered(beneficiaryAddresses[i], amounts[i]);\n', '        }\n', '    }\n', '\n', '}']