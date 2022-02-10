['pragma solidity ^0.4.16; \n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address owner) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '}\n', '\n', '\n', '\n', 'contract VRCoinCrowdsale {\n', '    // Information about a single period\n', '    struct Period\n', '    {\n', '         uint start;\n', '         uint end;\n', '         uint priceInWei;\n', '         uint tokenToDistibute;\n', '    }\n', '\n', '    // Some constant about our expected token distribution\n', '    uint public constant VRCOIN_DECIMALS = 9;\n', '    uint public constant TOTAL_TOKENS_TO_DISTRIBUTE = 750000 * (10 ** VRCOIN_DECIMALS); // 750000 VRtokenc\n', '    \n', '    uint public exchangeRate = 853;\n', '    \n', '    address public owner; // The owner of the crowdsale\n', '    bool public hasStarted; // Has the crowdsale started?\n', '    Period public sale; // The configured periods for this crowdsale\n', '    ERC20Interface public tokenWallet; // The token wallet contract used for this crowdsale\n', '\n', '    // The multiplier necessary to change a coin amount to the token amount\n', '    uint coinToTokenFactor = 10 ** VRCOIN_DECIMALS;\n', '    \n', '    // Fired once the transfer tokens to contract was successfull\n', '    event Transfer(address to, uint amount);\n', '\n', '    // Fired once the sale starts\n', '    event Start(uint timestamp);\n', '\n', '    // Fired whenever a contribution is made\n', '    event Contribution(address indexed from, uint weiContributed, uint tokensReceived);\n', '\n', '    function VRCoinCrowdsale(address walletAddress)\n', '    {\n', '         // Setup the owner and wallet\n', '         owner = msg.sender;\n', '         tokenWallet = ERC20Interface(walletAddress);\n', '\n', '         // Make sure the provided token has the expected number of tokens to distribute\n', '         require(tokenWallet.totalSupply() >= TOTAL_TOKENS_TO_DISTRIBUTE);\n', '\n', '         // Make sure the owner actually controls all the tokens\n', '         require(tokenWallet.balanceOf(owner) >= TOTAL_TOKENS_TO_DISTRIBUTE);\n', '\n', '         // We haven&#39;t started yet\n', '         hasStarted = false;\n', '                 \n', '         sale.start = 1521234001; // 00:00:01, March 05, 2018 UTC\n', '         sale.end = 1525122001; // 00:00:01, Apl 30, 2018 UTC\n', '         sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor); // 1 ETH = 750 VRCoin\n', '         sale.tokenToDistibute = TOTAL_TOKENS_TO_DISTRIBUTE;\n', '    }\n', '    \n', '    function updatePrice() {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '        \n', '         // Update price\n', '         sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor);\n', '    }\n', '    \n', '    function setExchangeRate(uint256 _rate) {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);        \n', '        \n', '         // The ether in $ dollar \n', '         exchangeRate = _rate;\n', '    }\n', '\n', '    // Start the crowdsale\n', '    function startSale()\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '         \n', '         // Cannot start if already started\n', '         require(hasStarted == false);\n', '\n', '         // Attempt to transfer all tokens to the crowdsale contract\n', '         // The owner needs to approve() the transfer of all tokens to this contract\n', '         if (!tokenWallet.transferFrom(owner, this, sale.tokenToDistibute))\n', '         {\n', '            // Something has gone wrong, the owner no longer controls all the tokens?\n', '            // We cannot proceed\n', '            revert();\n', '         }else{\n', '            Transfer(this, sale.tokenToDistibute);\n', '         }\n', '\n', '         // Sanity check: verify the crowdsale controls all tokens\n', '         require(tokenWallet.balanceOf(this) >= sale.tokenToDistibute);\n', '\n', '         // The sale can begin\n', '         hasStarted = true;\n', '\n', '         // Fire event that the sale has begun\n', '         Start(block.timestamp);\n', '    }\n', '\n', '    // Allow the current owner to change the owner of the crowdsale\n', '    function changeOwner(address newOwner) public\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', '         // Change the owner\n', '         owner = newOwner;\n', '    }\n', '\n', '    // Allow the owner to change the tokens for sale number\n', '    // But only if the sale has not begun yet\n', '    function changeTokenForSale(uint newAmount) public\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '         \n', '         // We can change period details as long as the sale hasn&#39;t started yet\n', '         require(hasStarted == false);\n', '         \n', '         // Make sure the provided token has the expected number of tokens to distribute\n', '         require(tokenWallet.totalSupply() >= newAmount);\n', '\n', '         // Make sure the owner actually controls all the tokens\n', '         require(tokenWallet.balanceOf(owner) >= newAmount);\n', '\n', '\n', '         // Change the price for this period\n', '         sale.tokenToDistibute = newAmount;\n', '    }\n', '\n', '    // Allow the owner to change the start/end time for a period\n', '    // But only if the sale has not begun yet\n', '    function changePeriodTime(uint start, uint end) public\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', '         // We can change period details as long as the sale hasn&#39;t started yet\n', '         require(hasStarted == false);\n', '\n', '         // Make sure the input is valid\n', '         require(start < end);\n', '\n', '         // Everything checks out, update the period start/end time\n', '         sale.start = start;\n', '         sale.end = end;\n', '    }\n', '\n', '    // Allow the owner to withdraw all the tokens remaining after the\n', '    // crowdsale is over\n', '    function withdrawTokensRemaining() public\n', '         returns (bool)\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', '         // Get the ending timestamp of the crowdsale\n', '         uint crowdsaleEnd = sale.end;\n', '\n', '         // The crowsale must be over to perform this operation\n', '         require(block.timestamp > crowdsaleEnd);\n', '\n', '         // Get the remaining tokens owned by the crowdsale\n', '         uint tokensRemaining = getTokensRemaining();\n', '\n', '         // Transfer them all to the owner\n', '         return tokenWallet.transfer(owner, tokensRemaining);\n', '    }\n', '\n', '    // Allow the owner to withdraw all ether from the contract after the\n', '    // crowdsale is over\n', '    function withdrawEtherRemaining() public\n', '         returns (bool)\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', '         // Transfer them all to the owner\n', '         owner.transfer(this.balance);\n', '\n', '         return true;\n', '    }\n', '\n', '    // Check how many tokens are remaining for distribution\n', '    function getTokensRemaining() public constant\n', '         returns (uint256)\n', '    {\n', '         return tokenWallet.balanceOf(this);\n', '    }\n', '\n', '    // Calculate how many tokens can be distributed for the given contribution\n', '    function getTokensForContribution(uint weiContribution) public constant \n', '         returns(uint tokenAmount, uint weiRemainder)\n', '    {\n', '         // The bonus for contributor\n', '         uint256 bonus = 0;\n', '         \n', '         // Get the ending timestamp of the crowdsale\n', '         uint crowdsaleEnd = sale.end;\n', '        \n', '         // The crowsale must be going to perform this operation\n', '         require(block.timestamp <= crowdsaleEnd);\n', '\n', '         // Get the price for this current period\n', '         uint periodPriceInWei = sale.priceInWei;\n', '\n', '         // Return the amount of tokens that can be purchased\n', '         \n', '         tokenAmount = weiContribution / periodPriceInWei;\n', '         \n', '\t \t\n', '            if (block.timestamp < 1521234001) {\n', '                // bonus for contributor from 5.03.2018 to 16.03.2018 \n', '                bonus = tokenAmount * 20 / 100;\n', '            } else if (block.timestamp < 1521925201) {\n', '                // bonus for contributor from 17.03.2018 to 24.03.2018 \n', '                bonus = tokenAmount * 15 / 100;\n', '            } else {\n', '                // bonus for contributor\n', '                bonus = tokenAmount * 10 / 100;\n', '            }\n', '\t\t \n', '\n', '            \n', '        tokenAmount = tokenAmount + bonus;\n', '        \n', '         // Return the amount of wei that would be left over\n', '         weiRemainder = weiContribution % periodPriceInWei;\n', '    }\n', '    \n', '    // Allow a user to contribute to the crowdsale\n', '    function contribute() public payable\n', '    {\n', '         // Cannot contribute if the sale hasn&#39;t started\n', '         require(hasStarted == true);\n', '\n', '         // Calculate the tokens to be distributed based on the contribution amount\n', '         var (tokenAmount, weiRemainder) = getTokensForContribution(msg.value);\n', '\n', '         // Need to contribute enough for at least 1 token\n', '         require(tokenAmount > 0);\n', '         \n', '         // Sanity check: make sure the remainder is less or equal to what was sent to us\n', '         require(weiRemainder <= msg.value);\n', '\n', '         // Make sure there are enough tokens left to buy\n', '         uint tokensRemaining = getTokensRemaining();\n', '         require(tokensRemaining >= tokenAmount);\n', '\n', '         // Transfer the token amount from the crowd sale&#39;s token wallet to the\n', '         // sender&#39;s token wallet\n', '         if (!tokenWallet.transfer(msg.sender, tokenAmount))\n', '         {\n', '            // Unable to transfer funds, abort transaction\n', '            revert();\n', '         }\n', '\n', '         // Return the remainder to the sender\n', '         msg.sender.transfer(weiRemainder);\n', '\n', '         // Since we refunded the remainder, the actual contribution is the amount sent\n', '         // minus the remainder\n', '         uint actualContribution = msg.value - weiRemainder;\n', '\n', '         // Record the event\n', '         Contribution(msg.sender, actualContribution, tokenAmount);\n', '    }\n', '    \n', '    function() payable\n', '    {\n', '        contribute();\n', '    } \n', '}']
['pragma solidity ^0.4.16; \n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint256);\n', '    function balanceOf(address owner) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '}\n', '\n', '\n', '\n', 'contract VRCoinCrowdsale {\n', '    // Information about a single period\n', '    struct Period\n', '    {\n', '         uint start;\n', '         uint end;\n', '         uint priceInWei;\n', '         uint tokenToDistibute;\n', '    }\n', '\n', '    // Some constant about our expected token distribution\n', '    uint public constant VRCOIN_DECIMALS = 9;\n', '    uint public constant TOTAL_TOKENS_TO_DISTRIBUTE = 750000 * (10 ** VRCOIN_DECIMALS); // 750000 VRtokenc\n', '    \n', '    uint public exchangeRate = 853;\n', '    \n', '    address public owner; // The owner of the crowdsale\n', '    bool public hasStarted; // Has the crowdsale started?\n', '    Period public sale; // The configured periods for this crowdsale\n', '    ERC20Interface public tokenWallet; // The token wallet contract used for this crowdsale\n', '\n', '    // The multiplier necessary to change a coin amount to the token amount\n', '    uint coinToTokenFactor = 10 ** VRCOIN_DECIMALS;\n', '    \n', '    // Fired once the transfer tokens to contract was successfull\n', '    event Transfer(address to, uint amount);\n', '\n', '    // Fired once the sale starts\n', '    event Start(uint timestamp);\n', '\n', '    // Fired whenever a contribution is made\n', '    event Contribution(address indexed from, uint weiContributed, uint tokensReceived);\n', '\n', '    function VRCoinCrowdsale(address walletAddress)\n', '    {\n', '         // Setup the owner and wallet\n', '         owner = msg.sender;\n', '         tokenWallet = ERC20Interface(walletAddress);\n', '\n', '         // Make sure the provided token has the expected number of tokens to distribute\n', '         require(tokenWallet.totalSupply() >= TOTAL_TOKENS_TO_DISTRIBUTE);\n', '\n', '         // Make sure the owner actually controls all the tokens\n', '         require(tokenWallet.balanceOf(owner) >= TOTAL_TOKENS_TO_DISTRIBUTE);\n', '\n', "         // We haven't started yet\n", '         hasStarted = false;\n', '                 \n', '         sale.start = 1521234001; // 00:00:01, March 05, 2018 UTC\n', '         sale.end = 1525122001; // 00:00:01, Apl 30, 2018 UTC\n', '         sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor); // 1 ETH = 750 VRCoin\n', '         sale.tokenToDistibute = TOTAL_TOKENS_TO_DISTRIBUTE;\n', '    }\n', '    \n', '    function updatePrice() {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '        \n', '         // Update price\n', '         sale.priceInWei = (1 ether) / (exchangeRate * coinToTokenFactor);\n', '    }\n', '    \n', '    function setExchangeRate(uint256 _rate) {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);        \n', '        \n', '         // The ether in $ dollar \n', '         exchangeRate = _rate;\n', '    }\n', '\n', '    // Start the crowdsale\n', '    function startSale()\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '         \n', '         // Cannot start if already started\n', '         require(hasStarted == false);\n', '\n', '         // Attempt to transfer all tokens to the crowdsale contract\n', '         // The owner needs to approve() the transfer of all tokens to this contract\n', '         if (!tokenWallet.transferFrom(owner, this, sale.tokenToDistibute))\n', '         {\n', '            // Something has gone wrong, the owner no longer controls all the tokens?\n', '            // We cannot proceed\n', '            revert();\n', '         }else{\n', '            Transfer(this, sale.tokenToDistibute);\n', '         }\n', '\n', '         // Sanity check: verify the crowdsale controls all tokens\n', '         require(tokenWallet.balanceOf(this) >= sale.tokenToDistibute);\n', '\n', '         // The sale can begin\n', '         hasStarted = true;\n', '\n', '         // Fire event that the sale has begun\n', '         Start(block.timestamp);\n', '    }\n', '\n', '    // Allow the current owner to change the owner of the crowdsale\n', '    function changeOwner(address newOwner) public\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', '         // Change the owner\n', '         owner = newOwner;\n', '    }\n', '\n', '    // Allow the owner to change the tokens for sale number\n', '    // But only if the sale has not begun yet\n', '    function changeTokenForSale(uint newAmount) public\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '         \n', "         // We can change period details as long as the sale hasn't started yet\n", '         require(hasStarted == false);\n', '         \n', '         // Make sure the provided token has the expected number of tokens to distribute\n', '         require(tokenWallet.totalSupply() >= newAmount);\n', '\n', '         // Make sure the owner actually controls all the tokens\n', '         require(tokenWallet.balanceOf(owner) >= newAmount);\n', '\n', '\n', '         // Change the price for this period\n', '         sale.tokenToDistibute = newAmount;\n', '    }\n', '\n', '    // Allow the owner to change the start/end time for a period\n', '    // But only if the sale has not begun yet\n', '    function changePeriodTime(uint start, uint end) public\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', "         // We can change period details as long as the sale hasn't started yet\n", '         require(hasStarted == false);\n', '\n', '         // Make sure the input is valid\n', '         require(start < end);\n', '\n', '         // Everything checks out, update the period start/end time\n', '         sale.start = start;\n', '         sale.end = end;\n', '    }\n', '\n', '    // Allow the owner to withdraw all the tokens remaining after the\n', '    // crowdsale is over\n', '    function withdrawTokensRemaining() public\n', '         returns (bool)\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', '         // Get the ending timestamp of the crowdsale\n', '         uint crowdsaleEnd = sale.end;\n', '\n', '         // The crowsale must be over to perform this operation\n', '         require(block.timestamp > crowdsaleEnd);\n', '\n', '         // Get the remaining tokens owned by the crowdsale\n', '         uint tokensRemaining = getTokensRemaining();\n', '\n', '         // Transfer them all to the owner\n', '         return tokenWallet.transfer(owner, tokensRemaining);\n', '    }\n', '\n', '    // Allow the owner to withdraw all ether from the contract after the\n', '    // crowdsale is over\n', '    function withdrawEtherRemaining() public\n', '         returns (bool)\n', '    {\n', '         // Only the owner can do this\n', '         require(msg.sender == owner);\n', '\n', '         // Transfer them all to the owner\n', '         owner.transfer(this.balance);\n', '\n', '         return true;\n', '    }\n', '\n', '    // Check how many tokens are remaining for distribution\n', '    function getTokensRemaining() public constant\n', '         returns (uint256)\n', '    {\n', '         return tokenWallet.balanceOf(this);\n', '    }\n', '\n', '    // Calculate how many tokens can be distributed for the given contribution\n', '    function getTokensForContribution(uint weiContribution) public constant \n', '         returns(uint tokenAmount, uint weiRemainder)\n', '    {\n', '         // The bonus for contributor\n', '         uint256 bonus = 0;\n', '         \n', '         // Get the ending timestamp of the crowdsale\n', '         uint crowdsaleEnd = sale.end;\n', '        \n', '         // The crowsale must be going to perform this operation\n', '         require(block.timestamp <= crowdsaleEnd);\n', '\n', '         // Get the price for this current period\n', '         uint periodPriceInWei = sale.priceInWei;\n', '\n', '         // Return the amount of tokens that can be purchased\n', '         \n', '         tokenAmount = weiContribution / periodPriceInWei;\n', '         \n', '\t \t\n', '            if (block.timestamp < 1521234001) {\n', '                // bonus for contributor from 5.03.2018 to 16.03.2018 \n', '                bonus = tokenAmount * 20 / 100;\n', '            } else if (block.timestamp < 1521925201) {\n', '                // bonus for contributor from 17.03.2018 to 24.03.2018 \n', '                bonus = tokenAmount * 15 / 100;\n', '            } else {\n', '                // bonus for contributor\n', '                bonus = tokenAmount * 10 / 100;\n', '            }\n', '\t\t \n', '\n', '            \n', '        tokenAmount = tokenAmount + bonus;\n', '        \n', '         // Return the amount of wei that would be left over\n', '         weiRemainder = weiContribution % periodPriceInWei;\n', '    }\n', '    \n', '    // Allow a user to contribute to the crowdsale\n', '    function contribute() public payable\n', '    {\n', "         // Cannot contribute if the sale hasn't started\n", '         require(hasStarted == true);\n', '\n', '         // Calculate the tokens to be distributed based on the contribution amount\n', '         var (tokenAmount, weiRemainder) = getTokensForContribution(msg.value);\n', '\n', '         // Need to contribute enough for at least 1 token\n', '         require(tokenAmount > 0);\n', '         \n', '         // Sanity check: make sure the remainder is less or equal to what was sent to us\n', '         require(weiRemainder <= msg.value);\n', '\n', '         // Make sure there are enough tokens left to buy\n', '         uint tokensRemaining = getTokensRemaining();\n', '         require(tokensRemaining >= tokenAmount);\n', '\n', "         // Transfer the token amount from the crowd sale's token wallet to the\n", "         // sender's token wallet\n", '         if (!tokenWallet.transfer(msg.sender, tokenAmount))\n', '         {\n', '            // Unable to transfer funds, abort transaction\n', '            revert();\n', '         }\n', '\n', '         // Return the remainder to the sender\n', '         msg.sender.transfer(weiRemainder);\n', '\n', '         // Since we refunded the remainder, the actual contribution is the amount sent\n', '         // minus the remainder\n', '         uint actualContribution = msg.value - weiRemainder;\n', '\n', '         // Record the event\n', '         Contribution(msg.sender, actualContribution, tokenAmount);\n', '    }\n', '    \n', '    function() payable\n', '    {\n', '        contribute();\n', '    } \n', '}']
