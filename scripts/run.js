
const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    // how is hre imported? everytime npx hardhat, you're getting the hre object built on the fly usin the hardhat.confi.js
    const joinSpaceFactory = await hre.ethers.getContractFactory("JoinSpace") // compiles our contract, and generates neccessary files in artifact director
    const joinSpaceContract = await joinSpaceFactory.deploy(); // hard hat will create a new local etheeum network for us, but only for this contract.After, script complete it will be destroyed. so, everytime we run our contract, it's run on fresh blockchain
    await joinSpaceContract.deployed(); // wait utill our contract is deployed

    console.log("Contract deployed to: ", joinSpaceContract.address)
    console.log("Contract deployed by", owner.address)

    let totalSpacers;
    totalSpacers = await joinSpaceContract.getTotalSpacers(); // we're not waitin for it like one below, cause it's view function i.e doesn't change state of deve
    // address id;
    // string feelingEmoji;
    // string countryEmoji;
    // string date; // Thur, Aug 08, 2022 at 2:00 PM UTC
    // WinStatus status;
    // WinType winType;
    const PENDING = "PENDING"
    const ETH = "ETH'"
    let joinSpaceTx = await joinSpaceContract.joinSpace({
        id: owner.address,
        feelingEmoji: "happy", // figure how u can store feelin emojis
        countryEmoji: "ET", 
        date: "Aug 19, 2022 at 6:40 PM",
        status: PENDING,
        winType: ETH
    });
    await joinSpaceTx.wait(); // i think we're waiting for it because, and this function changes state of the blockchain

    totalSpacers = await joinSpaceContract.getTotalSpacers();

    // add other persons to wave, (in our case we're gettin a random address, and using that to mimic other people waving)
    let joinSpaceTx2 = await joinSpaceContract.joinSpace({
        id: randomPerson.address,
        feelingEmoji: "happy", // figure how u can store feelin emojis
        countryEmoji: "ET", 
        date: "Aug 19, 2022 at 6:40 PM",
        status: PENDING,
        winType: ETH
    })
    await joinSpaceTx2.wait();
    
    totalSpacers = await joinSpaceContract.getTotalSpacers();
}

const runMain = async () => {
    try{
        await main();
        process.exit(0); // exit node process without error
    } catch(error){
        console.log(error);
        process.exit(1) // exit node process while indicatin 'Uncaught fatal exception' error
    
    }
}

runMain()