['pragma solidity ^0.4.21;\n', '\n', 'contract Items{\n', '    address owner;\n', '    address helper = 0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58;\n', '    \n', '    // Marketplace written by Etherguy and Poorguy\n', '    \n', '    // Change the below numbers to edit the development fee. \n', '    // This can also be done by calling SetDevFee and SetHFee \n', '    // Numbers are divided by 10000 to calcualte the cut \n', '    uint16 public DevFee = 500; // 500 / 10000 -> 5% \n', '    uint16 public HelperPortion = 5000; // 5000 / 10000 -> 50% (This is the cut taken from the total dev fee)\n', '    \n', '    // Increase in price \n', '    // 0 means that the price stays the same \n', '    // Again divide by 10000\n', '    // 10000 means: 10000/10000 = 1, which means the new price = OldPrice * (1 + (10000/1000)) = OldPrice * (1+1) = 2*OldPrice \n', '    // Hence the price doubles.\n', '    // This setting can be changed via SetPriceIncrease\n', '    // The maximum setting is the uint16 max value 65535 which means an insane increase of more than 6.5x \n', '    uint16 public PriceIncrease = 2000;\n', '    \n', '    struct Item{\n', '        address Owner;\n', '        uint256 Price;\n', '    }\n', '    \n', '    mapping(uint256 => Item) Market; \n', '    \n', '    uint256 public NextItemID = 0;\n', '    event ItemBought(address owner, uint256 id, uint256 newprice);\n', '    \n', '    function Items() public {\n', '        owner = msg.sender;\n', '        \n', '        // Add initial items here to created directly by contract release. \n', '        \n', '      //  AddMultipleItems(0.00666 ether, 3); // Create 3 items for 0.00666 ether basic price at start of contract.\n', '      \n', '      \n', '      // INITIALIZE 17 items so we can transfer ownership ...\n', '      AddMultipleItems(0.006666 ether, 36);\n', '      \n', '      \n', '      // SETUP their data \n', '      Market[0].Owner = 0x874c6f81c14f01c0cb9006a98213803cd7af745f;\n', '      Market[0].Price = 53280000000000000;\n', '      Market[1].Owner = 0x874c6f81c14f01c0cb9006a98213803cd7af745f;\n', '      Market[1].Price = 26640000000000000;\n', '      Market[2].Owner = 0xb080b202b921d0d1fd804d0071615eb09e326aac;\n', '      Market[2].Price = 854280000000000000;\n', '      Market[3].Owner = 0x874c6f81c14f01c0cb9006a98213803cd7af745f;\n', '      Market[3].Price = 26640000000000000;\n', '      Market[4].Owner = 0xb080b202b921d0d1fd804d0071615eb09e326aac;\n', '      Market[4].Price = 213120000000000000;\n', '      Market[5].Owner = 0x874c6f81c14f01c0cb9006a98213803cd7af745f;\n', '      Market[5].Price = 13320000000000000;\n', '      Market[6].Owner = 0xd33614943bcaadb857a58ff7c36157f21643df36;\n', '      Market[6].Price = 26640000000000000;\n', '      Market[7].Owner = 0x874c6f81c14f01c0cb9006a98213803cd7af745f;\n', '      Market[7].Price = 53280000000000000;\n', '      Market[8].Owner = 0xd33614943bcaadb857a58ff7c36157f21643df36;\n', '      Market[8].Price = 26640000000000000;\n', '      Market[9].Owner = 0x874c6f81c14f01c0cb9006a98213803cd7af745f;\n', '      Market[9].Price = 53280000000000000;\n', '      Market[10].Owner = 0x0960069855bd812717e5a8f63c302b4e43bad89f;\n', '      Market[10].Price = 13320000000000000;\n', '      Market[11].Owner = 0xd3dead0690e4df17e4de54be642ca967ccf082b8;\n', '      Market[11].Price = 13320000000000000;\n', '      Market[12].Owner = 0xc34434842b9dc9cab4e4727298a166be765b4f32;\n', '      Market[12].Price = 13320000000000000;\n', '      Market[13].Owner = 0xc34434842b9dc9cab4e4727298a166be765b4f32;\n', '      Market[13].Price = 13320000000000000;\n', '      Market[14].Owner = 0x874c6f81c14f01c0cb9006a98213803cd7af745f;\n', '      Market[14].Price = 53280000000000000;\n', '      Market[15].Owner = 0xd33614943bcaadb857a58ff7c36157f21643df36;\n', '      Market[15].Price = 26640000000000000;\n', '      Market[16].Owner = 0x3130259deedb3052e24fad9d5e1f490cb8cccaa0;\n', '      Market[16].Price = 13320000000000000;\n', '      // Uncomment to add MORE ITEMS\n', '     // AddMultipleItems(0.006666 ether, 17);\n', '    }\n', '    \n', '    // web function, return item info \n', '    function ItemInfo(uint256 id) public view returns (uint256 ItemPrice, address CurrentOwner){\n', '        return (Market[id].Price, Market[id].Owner);\n', '    }\n', '    \n', '    // Add a single item. \n', '    function AddItem(uint256 price) public {\n', '        require(price != 0); // Price 0 means item is not available. \n', '        require(msg.sender == owner);\n', '        Item memory ItemToAdd = Item(0x0, price); // Set owner to 0x0 -> Recognized as owner\n', '        Market[NextItemID] = ItemToAdd;\n', '        NextItemID = add(NextItemID, 1); // This absolutely prevents overwriting items\n', '    }\n', '    \n', '    // Add multiple items \n', '    // All for same price \n', '    // This saves sending 10 tickets to create 10 items. \n', '    function AddMultipleItems(uint256 price, uint8 howmuch) public {\n', '        require(msg.sender == owner);\n', '        require(price != 0);\n', '        require(howmuch != 255); // this is to prevent an infinite for loop\n', '        uint8 i=0;\n', '        for (i; i<howmuch; i++){\n', '            AddItem(price);\n', '        }\n', '    }\n', '    \n', '\n', '    function BuyItem(uint256 id) payable public{\n', '        Item storage MyItem = Market[id];\n', '        require(MyItem.Price != 0); // It is not possible to edit existing items.\n', '        require(msg.value >= MyItem.Price); // Pay enough thanks .\n', '        uint256 ValueLeft = DoDev(MyItem.Price);\n', '        uint256 Excess = sub(msg.value, MyItem.Price);\n', '        if (Excess > 0){\n', '            msg.sender.transfer(Excess); // Pay back too much sent \n', '        }\n', '        \n', '        // Proceed buy \n', '        address target = MyItem.Owner;\n', '        \n', '        // Initial items are owned by owner. \n', '        if (target == 0x0){\n', '            target = owner; \n', '        }\n', '        \n', '        target.transfer(ValueLeft);\n', '        // set owner and price. \n', '        MyItem.Price = mul(MyItem.Price, (uint256(PriceIncrease) + uint256(10000)))/10000; // division 10000 to scale stuff right. No need SafeMath this only errors when DIV by 0.\n', '        MyItem.Owner = msg.sender;\n', '        emit ItemBought(msg.sender, id, MyItem.Price);\n', '    }\n', '    \n', '    \n', '    \n', '    \n', '    \n', '    // Management stuff, not interesting after here .\n', '    \n', '    \n', '    function DoDev(uint256 val) internal returns (uint256){\n', '        uint256 tval = (mul(val, DevFee)) / 10000;\n', '        uint256 hval = (mul(tval, HelperPortion)) / 10000;\n', '        uint256 dval = sub(tval, hval); \n', '        \n', '        owner.transfer(dval);\n', '        helper.transfer(hval);\n', '        return (sub(val,tval));\n', '    }\n', '    \n', '    // allows to change dev fee. max is 6.5%\n', '    function SetDevFee(uint16 tfee) public {\n', '        require(msg.sender == owner);\n', '        require(tfee <= 650);\n', '        DevFee = tfee;\n', '    }\n', '    \n', '    // allows to change helper fee. minimum is 10%, max 100%. \n', '    function SetHFee(uint16 hfee) public  {\n', '        require(msg.sender == owner);\n', '        require(hfee <= 10000);\n', '\n', '        HelperPortion = hfee;\n', '    \n', '    }\n', '    \n', '    // allows to change helper fee. minimum is 10%, max 100%. \n', '    function SetPriceIncrease(uint16 increase) public  {\n', '        require(msg.sender == owner);\n', '        PriceIncrease = increase;\n', '    }\n', '    \n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tif (a == 0) {\n', '\t\t\treturn 0;\n', '\t\t}\n', '\t\tuint256 c = a * b;\n', '\t\tassert(c / a == b);\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\t// assert(b > 0); // Solidity automatically throws when dividing by 0\n', '\t\tuint256 c = a / b;\n', '\t\t// assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\t\treturn c;\n', '\t}\n', '\n', '\tfunction sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tassert(b <= a);\n', '\t\treturn a - b;\n', '\t}\n', '\n', '\tfunction add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\t\treturn c;\n', '\t}\n', '}']