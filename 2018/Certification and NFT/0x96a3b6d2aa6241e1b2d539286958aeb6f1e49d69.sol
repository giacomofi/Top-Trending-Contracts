['pragma solidity ^0.4.19;\n', '\n', '// Axie AOC sell contract. Not affiliated with the game developers. Use at your own risk.\n', '//\n', '// BUYERS: to protect against scams:\n', '// 1) check the price by clicking on "Read smart contract" in etherscan. Two prices are published\n', '//     a) price for 1 AOC in wei (1 wei = 10^-18 ETH), and b) number of AOC you get for 1 ETH\n', '// 2) Make sure you use high enough gas price that your TX confirms within 1 hour, to avoid the scam\n', '//    detailed below*\n', '// 3) Check the hardcoded AOC address below givet to AOCToken() constructor. Make sure this is the real AOC\n', '//    token. Scammers could clone this contract and modify the address to sell you fake tokens.\n', '//\n', '\n', '// This contract enables trustless exchange of AOC tokens for ETH.\n', '// Anyone can use this contract to sell AOC, as long as it is in an empty state.\n', '// Contract is in an empty state if it has no AOC or ETH in it and is not in cooldown\n', '// The main idea behind the contract is to keep it very simple to use, especially for buyers.\n', '// Sellers need to set allowance and call the setup() function using MEW, which is a little more involved.\n', '// Buyers can use Metamask to send and receive AOC tokens.\n', '//\n', '// To use the contract:\n', '// 1) Call approve on the AOC ERC20 address for this contract. That will allow the contract\n', '//    to hold your AOC tokens in escrow. You can always withdraw you AOC tokens back.\n', '//    You can make this call using MEW. The AOC contract address and ABI are available here:\n', '//    https://etherscan.io/address/0x73d7b530d181ef957525c6fbe2ab8f28bf4f81cf#code\n', '// 2) Call setup(AOC_amount, price) on this contract, for example by using MEW.\n', '//    This call will take your tokens and hold them in escrow, while at the same time\n', '//    you get the ownership of the contract. While you own the contract (i.e. while the contract\n', '//    holds your tokens or your ETH, nobody else can call setup(). If they do, the call will fail.\n', '//    If you call approve() on the AOC contract, but someone else calls setup() on this contract\n', '//    nothing bad happens. You can either wait for this contract to go into empty state, or find\n', '//    another contract (or publish your own). You will need to call approve() again for the new contract.\n', '// 3) Advertise the contract address so others can buy AOC from it. Buying AOC is simple, the\n', '//    buyer needs to send ETH to the contract address, and the contract sends them AOC. The buyer\n', '//    can verify the price by viewing the contract.\n', '// 4) To claim your funds back (both AOC and ETH resulting from any sales), simply send 0 ETH to\n', '//    the contract. The contract will send you ETH and AOC back, and reset the contract for others to use.\n', '//\n', '// *) There is a cooldown period of 1 hour after the contract is reset, before it can be used again.\n', '//    This is to avoid possible scams where the seller sees a pending TX on the contract, then resets\n', '//    the contract and call setup() is a much higher price. If the seller does that with very high gas price,\n', '//    they could change the price for the buyer&#39;s pending TX. A cooldown of 1 hour prevents this attac, as long\n', '//    as the buyer&#39;s TX confirms within the hour.\n', '\n', '\n', 'interface AOCToken {\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '}\n', '\n', 'contract AOCTrader {\n', '    AOCToken AOC = AOCToken(0x73d7B530d181ef957525c6FBE2Ab8F28Bf4f81Cf); // hardcoded AOC address to avoid scams.\n', '    address public seller;\n', '    uint256 public price; // price is in wei, not ether\n', '    uint256 public AOC_available; // remaining amount of AOC. This is just a convenience variable for buyers, not really used in the contract.\n', '    uint256 public Amount_of_AOC_for_One_ETH; // shows how much AOC you get for 1 ETH. Helps avoid price scams.\n', '    uint256 cooldown_start_time;\n', '\n', '    function AOCTrader() public {\n', '        seller = 0x0;\n', '        price = 0;\n', '        AOC_available = 0;\n', '        Amount_of_AOC_for_One_ETH = 0;\n', '        cooldown_start_time = 0;\n', '    }\n', '\n', '    // convenience is_empty function. Sellers should check this before using the contract\n', '    function is_empty() public view returns (bool) {\n', '        return (now - cooldown_start_time > 1 hours) && (this.balance==0) && (AOC.balanceOf(this) == 0);\n', '    }\n', '    \n', '    // Before calling setup, the sender must call Approve() on the AOC token \n', '    // That sets allowance for this contract to sell the tokens on sender&#39;s behalf\n', '    function setup(uint256 AOC_amount, uint256 price_in_wei) public {\n', '        require(is_empty()); // must not be in cooldown\n', '        require(AOC.allowance(msg.sender, this) >= AOC_amount); // contract needs enough allowance\n', '        require(price_in_wei > 1000); // to avoid mistakes, require price to be more than 1000 wei\n', '        \n', '        price = price_in_wei;\n', '        AOC_available = AOC_amount;\n', '        Amount_of_AOC_for_One_ETH = 1 ether / price_in_wei;\n', '        seller = msg.sender;\n', '\n', '        require(AOC.transferFrom(msg.sender, this, AOC_amount)); // move AOC to this contract to hold in escrow\n', '    }\n', '\n', '    function() public payable{\n', '        uint256 eth_balance = this.balance;\n', '        uint256 AOC_balance = AOC.balanceOf(this);\n', '        if(msg.sender == seller){\n', '            seller = 0x0; // reset seller\n', '            price = 0; // reset price\n', '            AOC_available = 0; // reset available AOC\n', '            Amount_of_AOC_for_One_ETH = 0; // reset price\n', '            cooldown_start_time = now; // start cooldown timer\n', '\n', '            if(eth_balance > 0) msg.sender.transfer(eth_balance); // withdraw all ETH\n', '            if(AOC_balance > 0) require(AOC.transfer(msg.sender, AOC_balance)); // withdraw all AOC\n', '        }        \n', '        else{\n', '            require(msg.value > 0); // must send some ETH to buy AOC\n', '            require(price > 0); // cannot divide by zero\n', '            uint256 num_AOC = msg.value / price; // calculate number of AOC tokens for the ETH amount sent\n', '            require(AOC_balance >= num_AOC); // must have enough AOC in the contract\n', '            AOC_available = AOC_balance - num_AOC; // recalculate available AOC\n', '\n', '            require(AOC.transfer(msg.sender, num_AOC)); // send AOC to buyer\n', '        }\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '// Axie AOC sell contract. Not affiliated with the game developers. Use at your own risk.\n', '//\n', '// BUYERS: to protect against scams:\n', '// 1) check the price by clicking on "Read smart contract" in etherscan. Two prices are published\n', '//     a) price for 1 AOC in wei (1 wei = 10^-18 ETH), and b) number of AOC you get for 1 ETH\n', '// 2) Make sure you use high enough gas price that your TX confirms within 1 hour, to avoid the scam\n', '//    detailed below*\n', '// 3) Check the hardcoded AOC address below givet to AOCToken() constructor. Make sure this is the real AOC\n', '//    token. Scammers could clone this contract and modify the address to sell you fake tokens.\n', '//\n', '\n', '// This contract enables trustless exchange of AOC tokens for ETH.\n', '// Anyone can use this contract to sell AOC, as long as it is in an empty state.\n', '// Contract is in an empty state if it has no AOC or ETH in it and is not in cooldown\n', '// The main idea behind the contract is to keep it very simple to use, especially for buyers.\n', '// Sellers need to set allowance and call the setup() function using MEW, which is a little more involved.\n', '// Buyers can use Metamask to send and receive AOC tokens.\n', '//\n', '// To use the contract:\n', '// 1) Call approve on the AOC ERC20 address for this contract. That will allow the contract\n', '//    to hold your AOC tokens in escrow. You can always withdraw you AOC tokens back.\n', '//    You can make this call using MEW. The AOC contract address and ABI are available here:\n', '//    https://etherscan.io/address/0x73d7b530d181ef957525c6fbe2ab8f28bf4f81cf#code\n', '// 2) Call setup(AOC_amount, price) on this contract, for example by using MEW.\n', '//    This call will take your tokens and hold them in escrow, while at the same time\n', '//    you get the ownership of the contract. While you own the contract (i.e. while the contract\n', '//    holds your tokens or your ETH, nobody else can call setup(). If they do, the call will fail.\n', '//    If you call approve() on the AOC contract, but someone else calls setup() on this contract\n', '//    nothing bad happens. You can either wait for this contract to go into empty state, or find\n', '//    another contract (or publish your own). You will need to call approve() again for the new contract.\n', '// 3) Advertise the contract address so others can buy AOC from it. Buying AOC is simple, the\n', '//    buyer needs to send ETH to the contract address, and the contract sends them AOC. The buyer\n', '//    can verify the price by viewing the contract.\n', '// 4) To claim your funds back (both AOC and ETH resulting from any sales), simply send 0 ETH to\n', '//    the contract. The contract will send you ETH and AOC back, and reset the contract for others to use.\n', '//\n', '// *) There is a cooldown period of 1 hour after the contract is reset, before it can be used again.\n', '//    This is to avoid possible scams where the seller sees a pending TX on the contract, then resets\n', '//    the contract and call setup() is a much higher price. If the seller does that with very high gas price,\n', "//    they could change the price for the buyer's pending TX. A cooldown of 1 hour prevents this attac, as long\n", "//    as the buyer's TX confirms within the hour.\n", '\n', '\n', 'interface AOCToken {\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '}\n', '\n', 'contract AOCTrader {\n', '    AOCToken AOC = AOCToken(0x73d7B530d181ef957525c6FBE2Ab8F28Bf4f81Cf); // hardcoded AOC address to avoid scams.\n', '    address public seller;\n', '    uint256 public price; // price is in wei, not ether\n', '    uint256 public AOC_available; // remaining amount of AOC. This is just a convenience variable for buyers, not really used in the contract.\n', '    uint256 public Amount_of_AOC_for_One_ETH; // shows how much AOC you get for 1 ETH. Helps avoid price scams.\n', '    uint256 cooldown_start_time;\n', '\n', '    function AOCTrader() public {\n', '        seller = 0x0;\n', '        price = 0;\n', '        AOC_available = 0;\n', '        Amount_of_AOC_for_One_ETH = 0;\n', '        cooldown_start_time = 0;\n', '    }\n', '\n', '    // convenience is_empty function. Sellers should check this before using the contract\n', '    function is_empty() public view returns (bool) {\n', '        return (now - cooldown_start_time > 1 hours) && (this.balance==0) && (AOC.balanceOf(this) == 0);\n', '    }\n', '    \n', '    // Before calling setup, the sender must call Approve() on the AOC token \n', "    // That sets allowance for this contract to sell the tokens on sender's behalf\n", '    function setup(uint256 AOC_amount, uint256 price_in_wei) public {\n', '        require(is_empty()); // must not be in cooldown\n', '        require(AOC.allowance(msg.sender, this) >= AOC_amount); // contract needs enough allowance\n', '        require(price_in_wei > 1000); // to avoid mistakes, require price to be more than 1000 wei\n', '        \n', '        price = price_in_wei;\n', '        AOC_available = AOC_amount;\n', '        Amount_of_AOC_for_One_ETH = 1 ether / price_in_wei;\n', '        seller = msg.sender;\n', '\n', '        require(AOC.transferFrom(msg.sender, this, AOC_amount)); // move AOC to this contract to hold in escrow\n', '    }\n', '\n', '    function() public payable{\n', '        uint256 eth_balance = this.balance;\n', '        uint256 AOC_balance = AOC.balanceOf(this);\n', '        if(msg.sender == seller){\n', '            seller = 0x0; // reset seller\n', '            price = 0; // reset price\n', '            AOC_available = 0; // reset available AOC\n', '            Amount_of_AOC_for_One_ETH = 0; // reset price\n', '            cooldown_start_time = now; // start cooldown timer\n', '\n', '            if(eth_balance > 0) msg.sender.transfer(eth_balance); // withdraw all ETH\n', '            if(AOC_balance > 0) require(AOC.transfer(msg.sender, AOC_balance)); // withdraw all AOC\n', '        }        \n', '        else{\n', '            require(msg.value > 0); // must send some ETH to buy AOC\n', '            require(price > 0); // cannot divide by zero\n', '            uint256 num_AOC = msg.value / price; // calculate number of AOC tokens for the ETH amount sent\n', '            require(AOC_balance >= num_AOC); // must have enough AOC in the contract\n', '            AOC_available = AOC_balance - num_AOC; // recalculate available AOC\n', '\n', '            require(AOC.transfer(msg.sender, num_AOC)); // send AOC to buyer\n', '        }\n', '    }\n', '}']
