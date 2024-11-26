import { dice } from "./battles.js";
import {l} from "./l.js";

const root = l("div");
document.body.appendChild(root);

let lroll;
let loffence;
let ldefense;
l(root, {},
    "offense", loffence = l("input", {type: "number", defaultValue: "5"}),
    "defense", ldefense = l("input", {type: "number", defaultValue: "4"}),
    l("br"),
    lroll = l("button", {onclick: froll}, "roll"),
)

froll();

let droll: void | HTMLDivElement;
function froll() {
    if (droll) {
        droll.remove();
    }
    droll = l("div", {style: {display: "flex", flexDirection: "column", gap: "1em"}});
    root.appendChild(droll);
    const roll1 = l("div", {style: {display: "flex", gap: "1em"}});
    droll.appendChild(roll1);
    const offense = Number(loffence.value);
    const defence = Number(ldefense.value);


    const rolls = Array.from({length: offense}, dice);
    rolls.sort((a, b) => a - b);
    const left_rolls: number[] = [];
    for (const roll of rolls) {
        const num = l("div", {}, `${roll}`);
        const lr = l("div", {className: "dice"}, num);
        roll1.appendChild(lr);
        if (roll == 0) {
            num.classList.add("discard");
        } else
        if (roll >= defence) {
            num.classList.add("outline");
        } else {
            left_rolls.push(roll);
        }
    }
    
    const roll2 = l("div", {style: {display: "flex", gap: "1em"}});
    droll.appendChild(roll2);

    for (const roll of left_rolls) {
        const num = l("div", {}, `${roll}`);
        const die = l("div", {className: "dice", onclick: e => {
            num.classList.toggle("discard");
        }}, num);
        roll2.appendChild(die);
    }
}