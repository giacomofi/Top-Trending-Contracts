['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-19\n', '*/\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', '// UniPower.Network - PowerDAO beta\n', '\n', 'contract PowerDAOBeta {\n', '    \n', '    ERC20 constant power = ERC20(0xF2f9A7e93f845b3ce154EfbeB64fB9346FCCE509);\n', '    ERC20 constant liquidity = ERC20(0x49F9316EB22de90d9343C573fbD7Cc0B5ec6e19f);\n', '    PowerLock constant powerLock = PowerLock(0xAE7B530Be880457523Eb46d8ec6484e067c018B4);\n', '    StaticPower constant staticPower = StaticPower(0xBaB61589f963534460E2764A1C0d840B745A9140);\n', '    \n', '    address blobby = msg.sender; // For beta (updating proposal cost)\n', '    uint256 proposalDeposit = 50 * (10 ** 18); // 50 POWER\n', '    uint256 proposalExpiration = 7 days;\n', '    //uint256 removalCap = 5; // No cap for beta\n', '    uint256 removalCooldown = 24 hours;\n', '    uint256 nextRemoval;\n', '    \n', '    Proposal[] public proposals;\n', '    \n', '    struct Proposal {\n', '        address creator;\n', '        uint200 liquidityRemoved;\n', '        uint40 expiration;\n', '        bool executed;\n', '        address recipient;\n', '        string title;\n', '        string message;\n', '    }\n', '    \n', '    function startProposal(uint200 liquidityRemoved, address recipient, string title, string message) external {\n', '        //uint256 maxRemoval = (removalCap * liquidity.balanceOf(this)) / 100; TODO No cap for beta\n', '        //require(liquidityRemoved <= maxRemoval);\n', '        power.transferFrom(msg.sender, this, proposalDeposit);\n', '        proposals.push(Proposal(msg.sender, liquidityRemoved, uint40(now + proposalExpiration), false, recipient, title, message));\n', '    }\n', '    \n', '    function updateProposalDeposit(uint256 newCost) external {\n', '        require(msg.sender == blobby);\n', '        require(newCost <= 500 * (10 ** 18)); // upto 500 POWER\n', '        proposalDeposit = newCost;\n', '    }\n', '    \n', '    function updateProposalExpiration(uint256 newTime) external {\n', '        require(msg.sender == blobby);\n', '        require(newTime > 3 days && newTime < 31 days);\n', '        proposalExpiration = newTime;\n', '    }\n', '    \n', '    /*function updateProposalCap(uint256 newCap) external {\n', '        require(msg.sender == blobby);\n', '        require(newCap <= 10);\n', '        removalCap = newCap;\n', '    }*/\n', '    \n', '    function updateRemovalFrequency(uint256 newLimit) external {\n', '        require(msg.sender == blobby);\n', '        require(newLimit > 12 hours && newLimit < 7 days);\n', '        removalCooldown = newLimit;\n', '    }\n', '    \n', '    function removeExpiredDeposits(address recipient, uint256 amount) external {\n', '        require(msg.sender == blobby);\n', '        power.transfer(recipient, amount);\n', '    }\n', '    \n', '    function executeProposal(uint256 proposalId, bytes signatures) external {\n', '        Proposal memory proposal = proposals[proposalId];\n', '        require(proposal.creator != 0);\n', '        require(!proposal.executed);\n', '        \n', '        // Check signatures add up to required 50%\n', '        uint256 tally;\n', '        bytes32 hashedTx = recoverPreSignedHash(proposalId);\n', '        address previousAddress;\n', '        for (uint256 i = 0; (i * 65) < signatures.length; i++) {\n', '            address user = recover(hashedTx, slice(signatures, i * 65, 65));\n', '            require(user > previousAddress);\n', '            previousAddress = user;\n', '            if (user != 0) {\n', '                tally += powerLock.playersStakePower(user);\n', '                tally += staticPower.balanceOf(user);\n', '            }\n', '        }\n', '        \n', '        if (proposalId > 0) { // 0 is test proposal\n', '            require(tally >= ((powerLock.totalStakePower() + staticPower.totalSupply()) * 50) / 100); // 50% in PowerLock & StaticPower\n', '        }\n', '        \n', '        if (proposal.liquidityRemoved > 0) {\n', '            require(nextRemoval < now);\n', '            liquidity.transfer(proposal.recipient, proposal.liquidityRemoved);\n', '            nextRemoval = now + removalCooldown;\n', '        }\n', '        \n', '        proposal.executed = true;\n', '        proposal.expiration = uint40(now);\n', '        proposals[proposalId] = proposal;\n', '        power.transfer(proposal.creator, proposalDeposit);\n', '    }\n', '    \n', '    function numProposals() view external returns(uint256) {\n', '        return proposals.length;\n', '    }\n', '    \n', '    function recoverPreSignedHash(uint256 proposalId) public pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked("powerdao", proposalId));\n', '    }\n', '    \n', '    function signaturesAddress(bytes signature, uint256 proposalId) external pure returns (address) {\n', '        bytes32 hashedTx = recoverPreSignedHash(proposalId);\n', '        return recover(hashedTx, signature);\n', '    }\n', '\n', '    function recover(bytes32 hash, bytes sig) public pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '        \n', '        // Check the signature length\n', '        if (sig.length != 65) {\n', '            return address(0);\n', '        }\n', '        \n', '        // Divide the signature in r, s and v variables\n', '        assembly {\n', '            r := mload(add(sig, 32))\n', '            s := mload(add(sig, 64))\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '        \n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '        \n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            bytes memory prefix = "\\x19Ethereum Signed Message:\\n32";\n', '            bytes32 prefixedHash = keccak256(prefix, hash);\n', '            return ecrecover(prefixedHash, v, r, s);\n', '        }\n', '    }\n', '    \n', '    function getTally(bytes signatures, uint256 proposalId) external view returns (uint256, uint256) {\n', '        uint256 tally;\n', '        bytes32 hashedTx = recoverPreSignedHash(proposalId);\n', '        address previousAddress;\n', '        \n', '        for (uint256 i = 0; (i * 65) < signatures.length; i++) {\n', '            address user = recover(hashedTx, slice(signatures, i * 65, 65));\n', '            require(user > previousAddress);\n', '            previousAddress = user;\n', '            if (user != 0) {\n', '                tally += powerLock.playersStakePower(user);\n', '                tally += staticPower.balanceOf(user);\n', '            }\n', '        }\n', '        \n', '        uint256 required = ((powerLock.totalStakePower() + staticPower.totalSupply()) * 50) / 100;\n', '        return (tally, required);\n', '    }\n', '    \n', '    function slice(bytes memory _bytes, uint256 _start, uint256 _length) internal pure returns (bytes memory) {\n', '        require(_length + 31 >= _length, "slice_overflow");\n', '        require(_start + _length >= _start, "slice_overflow");\n', '        require(_bytes.length >= _start + _length, "slice_outOfBounds");\n', '\n', '        bytes memory tempBytes;\n', '\n', '        assembly {\n', '            switch iszero(_length)\n', '            case 0 {\n', '                // Get a location of some free memory and store it in tempBytes as\n', '                // Solidity does for memory variables.\n', '                tempBytes := mload(0x40)\n', '\n', '                // The first word of the slice result is potentially a partial\n', '                // word read from the original array. To read it, we calculate\n', '                // the length of that partial word and start copying that many\n', '                // bytes into the array. The first word we copy will start with\n', "                // data we don't care about, but the last `lengthmod` bytes will\n", '                // land at the beginning of the contents of the new array. When\n', "                // we're done copying, we overwrite the full first word with\n", '                // the actual length of the slice.\n', '                let lengthmod := and(_length, 31)\n', '\n', '                // The multiplication in the next line is necessary\n', '                // because when slicing multiples of 32 bytes (lengthmod == 0)\n', "                // the following copy loop was copying the origin's length\n", '                // and then ending prematurely not copying everything it should.\n', '                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))\n', '                let end := add(mc, _length)\n', '\n', '                for {\n', '                    // The multiplication in the next line has the same exact purpose\n', '                    // as the one above.\n', '                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)\n', '                } lt(mc, end) {\n', '                    mc := add(mc, 0x20)\n', '                    cc := add(cc, 0x20)\n', '                } {\n', '                    mstore(mc, mload(cc))\n', '                }\n', '\n', '                mstore(tempBytes, _length)\n', '\n', '                //update free-memory pointer\n', '                //allocating the array padded to 32 bytes like the compiler does now\n', '                mstore(0x40, and(add(mc, 31), not(31)))\n', '            }\n', "            //if we want a zero-length slice let's just return a zero-length array\n", '            default {\n', '                tempBytes := mload(0x40)\n', '                //zero out the 32 bytes slice we are about to return\n', '                //we need to do it because Solidity does not garbage collect\n', '                mstore(tempBytes, 0)\n', '\n', '                mstore(0x40, add(tempBytes, 0x20))\n', '            }\n', '        }\n', '\n', '        return tempBytes;\n', '    }\n', '    \n', '}\n', '\n', '\n', 'contract PowerLock {\n', '    uint256 public totalStakePower;\n', '    mapping(address => uint256) public playersStakePower;\n', '    function distributeDivs(uint256 amount) external;\n', '}\n', '\n', 'contract StaticPower {\n', '    function distribute(uint256 _amount) public returns(uint256);\n', '    function balanceOf(address _customerAddress) public view returns(uint256);\n', '    function totalSupply() public view returns(uint256);\n', '}\n', '\n', 'contract Uniswap {\n', '    function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) public;\n', '    function swapExactETHForTokens(uint amountOutMin, address[] path, address to, uint deadline) external payable returns (uint[] memory amounts);\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() external constant returns (uint);\n', '    function balanceOf(address tokenOwner) external constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) external constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}']