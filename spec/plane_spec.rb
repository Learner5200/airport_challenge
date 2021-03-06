require 'plane'

describe Plane do
  let(:plane) { Plane.new }
  let(:airport) { double(:airport, weather: "sunny", full?: false, planes: []) }

  describe "#land" do

    context "plane is able to land" do
      before { plane.land(airport) }

      it "should update its location upon landing" do
        expect(plane.location).to eq(airport)
      end

      it "should update airport's planes upon landing" do
        expect(airport.planes).to include(plane)
      end
    end

    context "plane is unable to land" do
      it "cannot land if airport is full" do
        allow(airport).to receive(:full?).and_return(true)
        expect { plane.land(airport) }.to raise_error("Airport is full!")
      end

      it "cannot land in a storm" do
        allow(airport).to receive(:weather).and_return("stormy")
        expect { plane.land(airport) }.to raise_error("Can't land - too stormy!")
      end

      it "cannot land when already in an airport" do
        plane.land(airport)
        expect { plane.land(airport) }.to raise_error("Can't land when already in an airport!")
      end
    end
  end

  describe "#take_off" do
    context "plane is able to take off" do
      before { plane.land(airport); plane.take_off(airport) }

      it "should update its location upon take-off" do
        expect(plane.location).to eq("sky")
      end

      it "should update airport's planes upon take-off" do
        expect(airport.planes).not_to include(plane)
      end
    end

    context "plane is unable to take off" do
      it "doesn't take off in a storm" do
        allow(airport).to receive(:weather).and_return("stormy")
        expect { plane.take_off(airport) }.to raise_error("Can't take off - too stormy!")
      end

      it "can only take off from airport it is in" do
        expect { plane.take_off(airport) }.to raise_error("The plane is not in that airport.")
      end
    end
  end
end
