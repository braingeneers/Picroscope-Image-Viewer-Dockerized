<template>
  <div>
    <template v-if="manifest.captures.length > 0">
      <div>Images for {{ uuid }}</div>
      <!-- Hard code as we can't determine from manifest row and column -->
      <table id="picture-grid">
        <tr v-for="row in 4" :key="row">
          <td v-for="col in 6" :key="row * 10 + col">
            <img v-on:click="onClick" class="capture" @error="missing" v-bind:data-row="row" v-bind:data-col="col"
                 :src="`${endpoint}/${uuid}/images/${manifest.captures[firstLoadIndex]}/camera${groupID}${row}${col}/${0 + 1}.jpg`"/>
          </td>
        </tr>
      </table>
    </template>
    <template v-if="manifest.captures.length > 0">
      <div>Row: {{ curRow }} Col: {{ curCol }}</div>
      <div style="padding-top: 1vw">
           <button id="Arrow48Left" type="button" v-on:click="OnArrow48LeftClick">
                  Back 48 Timesteps
           </button>
           <button id="ArrowLeft" type="button" v-on:click="OnArrowLeftClick">
                  Previous Timestamp
           </button>
           Current Timestamp: {{this.curTimestampIndex+1}}/{{ this.manifest.captures.length}}
           <button id="ArrowRight" type="button" v-on:click="OnArrowRightClick">
                  Next Timestamp
           </button>
           <button id="Arrow48Right" type="button" v-on:click="OnArrow48RightClick">
                  Forward 48 Timesteps
           </button>
      </div>
      <div style="padding-top: 1vw">

          T: {{ manifest.captures[curTimestampIndex] }} Z: {{ curZ+1 }}/{{this.manifest.stack_size}}
          <button v-on:click="OnPreviousFocalViewClick">
              Previous Focal View
          </button>

          <button v-on:click="OnNextFocalViewClick" >
              Next Focal View
          </button>
      </div>
      <div style="position:relative;">


          <img style = "max-width:50%; max-height:50%;" v-pan="onPan" class="capture" @error="missing"
               :src="`${endpoint}/${uuid}/images/${manifest.captures[curTimestampIndex]}/camera${groupID}${curRow}${curCol}/${curZ + 1}.jpg`" />


      </div>
    </template>
  </div>
</template>

<script>
export default {
  name: 'ImagesWord',
  props: ["uuid","groupID", "endpoint","loadTrigger"],
  data: function() {
    return {
      manifest: {
        stack_size: 0,
        captures: []
      },
      // manifest.captures.length - 1
      curTimestampIndex: 0,
      curZ: 0,
      curRow: 1,
      curCol: 1,
      firstLoadIndex: 0,
      startTimestampIndex: 0,
      startZ: 0,
      panning: false
    }
  },
  watch: {
    loadTrigger: function() {
      // console.log(newVal, oldVal)
      // console.log("testProp got hit")
      this.loader("newest")
    }
  },
  methods: {
    loader(start_index) {
      console.log(start_index)
      console.log("Loading...", this.uuid)
      console.log(`${this.endpoint}/${this.uuid}/images/manifest.json`)
      fetch(`${this.endpoint}/${this.uuid}/images/manifest.json`)
        .then(stream => stream.json())
        .then(data => {
          this.manifest = data
          switch(start_index){
            case "newest":
              this.curTimestampIndex = this.manifest.captures.length -1
              this.firstLoadIndex = this.manifest.captures.length -1
              break;
            case "oldest":
              this.curTimestampIndex = 0
              this.firstLoadIndex = 0
              break;
            case "sync":
              this.firstLoadIndex = this.curTimestampIndex
              break;
            default:
              console.log(this.loadTrigger)

          }
        })
        .catch(error => {
          console.log(error)
          alert("Unable to load experiment, does the uuid exist?")
        })
    },
    missing(event) {
      console.log("Missing image", event.target.src)
      event.target.src = require("../assets/braingeneers_smooth_logo4.png")
    },
    onClick(event) {
      this.curRow = event.target.dataset.row
      this.curCol = event.target.dataset.col
      },
      OnArrowRightClick() {
          console.log()
        if (this.curTimestampIndex < this.manifest.captures.length-1) {
              this.curTimestampIndex = this.curTimestampIndex + 1
        }
        else {
            console.log("At max timestamp")
            console.log("this.curTimestampIndex: "+ this.curTimestampIndex)
        }
      },
      OnArrow48RightClick() {
          console.log()
          if (this.curTimestampIndex < this.manifest.captures.length-49) {
              this.curTimestampIndex = this.curTimestampIndex + 48
        }
        else {
            this.curTimestampIndex = this.manifest.captures.length-1
            console.log("At max timestamp")
            console.log("this.curTimestampIndex: "+ this.curTimestampIndex)
        }
      },
      OnArrowLeftClick() {
          console.log()
          if (this.curTimestampIndex > 0) {
              this.curTimestampIndex = this.curTimestampIndex - 1
        }
        else {
            console.log("At minimum timestamp")
            console.log("this.curTimestampIndex: "+ this.curTimestampIndex)
        }
      },
      OnArrow48LeftClick() {
          console.log()
          if (this.curTimestampIndex > 48) {
              this.curTimestampIndex = this.curTimestampIndex - 48
        }
        else {
            this.curTimestampIndex = 0
            console.log("At first timestamp")
            console.log("this.curTimestampIndex: "+ this.curTimestampIndex)
        }
      },
      OnPreviousFocalViewClick() {
          if (this.curZ > 0) {
          console.log("this.curZ: " + this.curZ)
          this.startZ = this.curZ
          this.curZ = this.startZ - 1

          } else {
              console.log("At minimum focal length")
          }
      },
      OnNextFocalViewClick() {
          if (this.curZ < this.manifest.stack_size-1) {
          console.log("this.curZ: " + this.curZ)
          this.startZ = this.curZ
          this.curZ = this.startZ + 1

          } else {
              console.log("At maximum focal length")
          }
      },
    onPan(event) {
      // 0 = none, 2 = left, 4 = right, 8 = up, 16 = down,
      if (!this.panning) {
        this.panning = true
        this.startTimestampIndex = this.curTimestampIndex
        this.startZ = this.curZ
      } else if (event.isFinal) {
        this.panning = false
      } else if (event.direction == 2 || event.direction == 4) {
        this.curTimestampIndex = Math.round(
          Math.min(Math.max(
            this.startTimestampIndex + event.deltaX / 25,
              0), this.manifest.captures.length - 1))
          /*var printMe = this.startTimestampIndex + event.deltaX / 25*/
          console.log("this.curTimestampIndex: " + this.curTimestampIndex)
      } else if (event.direction == 8 || event.direction == 16) {
        this.curZ = Math.round(
          Math.min(Math.max(
            this.startZ + event.deltaY / 25,
            0), this.manifest.stack_size - 1))
      }
    }
  },
}
</script>

<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}

.capture {
  width: 60%;
}

</style>
